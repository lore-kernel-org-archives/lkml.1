Return-Path: <linux-kernel-owner+w=401wt.eu-S965600AbXAWXlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600AbXAWXlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965601AbXAWXlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:41:08 -0500
Received: from mail1.key-systems.net ([81.3.43.211]:52768 "HELO
	mail1.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965600AbXAWXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:41:06 -0500
Message-ID: <45B69D0C.8030501@scientia.net>
Date: Wed, 24 Jan 2007 00:41:00 +0100
From: Christoph Anton Mitterer <calestyo@scientia.net>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Strange 
Content-Type: multipart/mixed;
 boundary="------------080002000906090208000806"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080002000906090208000806
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi.

I'm using a kernel 2.6.18.1 with a Plextor PX-769A CD/DVD drive (using
the old IDE drivers)... The drive itself is brand-new. The firmware
version is 1.06 (which is the most recent).

There are to issues I experience.

1) On some (but not all) DVD-Videos I get the following messages:

kernel: hdb: command error: status=0x51 { DriveReady SeekComplete Error }
kernel: hdb: command error: error=0x54 { AbortedCommand
LastFailedSense=0x05 }
kernel: ide: failed opcode was: unknown
kernel: ATAPI device hdb:
kernel:   Error: Illegal request -- (Sense key=0x05)
kernel:   Read of scrambled sector without authentication -- (asc=0x6f,
ascq=0x03)
kernel:   The failed "Read 10" packet command was:
kernel:   "28 00 00 00 01 38 00 00 01 00 00 00 00 00 00 00 "
kernel: end_request: I/O error, dev hdb, sector 1248

What do they mean? Does it indicate a damage in the drive? Or a firmware
error? Anyway I can read the contents of the media (and watch the movies
on it)....

The error appears after mounting the discs (but as I've said, not with
every disc).

Any ideas?



2) As far as I can remember, when a disc was mounted, the eject button
was disabled. But now, when I press the eject button, the disc is
ejected (and it seems that it is unmounted, at least mount doesn't show
it any longer).

Is this the correct behaviour? I'd doubt that.




Thanks in advance,
Chris.

--------------080002000906090208000806
Content-Type: text/x-vcard; charset=utf-8;
 name="calestyo.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="calestyo.vcf"

YmVnaW46dmNhcmQNCmZuOk1pdHRlcmVyLCBDaHJpc3RvcGggQW50b24NCm46TWl0dGVyZXI7
Q2hyaXN0b3BoIEFudG9uDQplbWFpbDtpbnRlcm5ldDpjYWxlc3R5b0BzY2llbnRpYS5uZXQN
CngtbW96aWxsYS1odG1sOlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------080002000906090208000806--
