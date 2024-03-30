class Seat:
    def __init__(self, seatId, isUsed):
        self.seatId = seatId
        self.isUsed = isUsed

def create_seat(seatId, isUsed):
    return Seat(seatId=seatId, isUsed=isUsed)
