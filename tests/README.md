## LuaJIT
#### JIT: ON SSE3 SSE4.1 BMI2 fold cse dce fwd dse narrow loop abc sink fuse
| Serializer                                        | sum      | avg      | med      | size
| ------------------------------------------------- | -------- | -------- | -------- | --
| yads serial                                       | 0.870000 | 0.087000 | 0.087000 | 76
| yads de/serial                                    | 1.503000 | 0.150300 | 0.150500 | --
| [von](https://github.com/vercas/vON) serial       | 2.738000 | 0.273800 | 0.274000 | 90
| [von](https://github.com/vercas/vON) de/serial    | 6.545000 | 0.654500 | 0.655000 | --
| [json](https://github.com/rxi/json.lua) serial    | 2.703000 | 0.270300 | 0.271000 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 7.107000 | 0.710700 | 0.713500 | --
| pon serial                                        | 2.027000 | 0.202700 | 0.202000 | 92
| pon de/serial                                     | 4.320000 | 0.432000 | 0.435000 | --

#### JIT: ON SSE3 SSE4.1 BMI2
| Serializer                                        | sum      | avg      | med      | size
| ------------------------------------------------- | -------- | -------- | -------- | --
| yads serial                                       | 1.230000 | 0.123000 | 0.123500 | 76
| yads de/serial                                    | 2.096000 | 0.209600 | 0.209000 | --
| [von](https://github.com/vercas/vON) serial       | 2.796000 | 0.279600 | 0.280500 | 90
| [von](https://github.com/vercas/vON) de/serial    | 6.773000 | 0.677300 | 0.679000 | --
| [json](https://github.com/rxi/json.lua) serial    | 2.509000 | 0.250900 | 0.252500 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 8.366000 | 0.836600 | 0.838500 | --
| pon serial                                        | 2.030000 | 0.203000 | 0.203500 | 92
| pon de/serial                                     | 4.313000 | 0.431300 | 0.429500 | --

#### JIT: OFF SSE3 SSE4.1 BMI2
| Serializer                                        | sum       | avg      | med      | size
| ------------------------------------------------- | --------- | -------- | -------- | --
| yads serial                                       | 2.938000  | 0.293800 | 0.296500 | 76
| yads de/serial                                    | 5.078000  | 0.507800 | 0.511000 | --
| [von](https://github.com/vercas/vON) serial       | 3.539000  | 0.279600 | 0.280500 | 90
| [von](https://github.com/vercas/vON) de/serial    | 9.367000  | 0.936700 | 0.944500 | --
| [json](https://github.com/rxi/json.lua) serial    | 3.939000  | 0.393900 | 0.387000 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 12.852000 | 1.285200 | 1.273500 | --
| pon serial                                        | 3.207000  | 0.320700 | 0.321000 | 92
| pon de/serial                                     | 6.497000  | 0.649700 | 0.646500 | --

## Lua 5.4
| Serializer                                        | sum       | avg      | med      | size
| ------------------------------------------------- | --------- | -------- | -------- | --
| yads serial                                       | 5.604000  | 0.560400 | 0.557000 | 76
| yads de/serial                                    | 10.510000 | 1.051000 | 1.050000 | --
| [von](https://github.com/vercas/vON) serial       | 9.385000  | 0.938500 | 0.942500 | 90
| [von](https://github.com/vercas/vON) de/serial    | 21.409000 | 2.140900 | 2.148000 | --
| [json](https://github.com/rxi/json.lua) serial    | 11.091000 | 1.109100 | 1.117500 | 97
| [json](https://github.com/rxi/json.lua) de/serial | 27.936000 | 2.793600 | 2.790000 | --
| pon serial                                        | 6.728000  | 0.672800 | 0.667500 | 92
| pon de/serial                                     | 14.006000 | 1.400600 | 1.389500 | --