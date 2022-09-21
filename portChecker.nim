import sugar
import std/strutils
import std/sequtils
import std/httpclient
import iputils

const source = "https://ipv6.icanhazip.com"

proc getGlobalIp(): Ipv6 =
  # based on https://github.com/no-waves/nip/blob/a4e7c13a91f7b8e5601421ead9ef49061711db62/nip.nim

  var client = newHttpClient()
  var s: string
  let response = client.getContent(source)
  s = response.strip()
  client.close()
  result = parseIpv6(s)

proc calcPorts(ipv6: Ipv6): seq[uint16] =
  let bits: uint16 = ipv6[6]
  result = collect(newSeq):
    for a in 1'u16..15:
      for b in 0'u16..15:
        (a shl 12) or (bits shl 4) or b


proc testCalcPorts() =
  let hexIp: array[8, uint16] = [0x240b'u16,
                                 0x10'u16,
                                 0x2761'u16,
                                 0x1100'u16,
                                 0x3e84'u16,
                                 0x0'u16,
                                 0x0'u16,
                                 0x1004'u16]
  var ipv6: Ipv6
  for i, n in hexIp:
    ipv6[i * 2] = uint8(n shr 8)
    ipv6[i * 2 + 1] = uint8(n and 0xFF'u16)

  let ports: seq[uint16] = ipv6.calcPorts
  echo ports


proc main() =
  let ipv6: Ipv6 = getGlobalIp()
  let ports: seq[uint16] = ipv6.calcPorts
  echo ports

if isMainModule:
  main()
