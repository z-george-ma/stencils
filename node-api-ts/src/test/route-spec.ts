///<reference path='../typings/tsd'/>

import * as routes from "../lib/route"

describe("Route", () => {
  let res

  beforeEach(() => {
    res = { 
      status: (x) => res,
      end:    (x) => {}
    }
    
    spyOn(res, 'status').andCallThrough()
    spyOn(res, 'end')
  });

  it("when index should return 200", () => {
    routes.index(null, res);
    expect(res.status).toHaveBeenCalledWith(200)
    expect(res.end).toHaveBeenCalled()
  })
  
  it("when healthcheck should return 200", () => {
    routes.healthcheck(null, res);
    expect(res.status).toHaveBeenCalledWith(200)
    expect(res.end).toHaveBeenCalledWith("Server OK!")
  })  
})

