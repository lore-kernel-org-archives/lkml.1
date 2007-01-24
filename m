Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbXAXAB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbXAXAB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXAXAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:01:27 -0500
Received: from mail1.key-systems.net ([81.3.43.211]:53001 "HELO
	mail1.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933143AbXAXAB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:01:27 -0500
Message-ID: <45B6A1D4.7020906@scientia.net>
Date: Wed, 24 Jan 2007 01:01:24 +0100
From: Christoph Anton Mitterer <calestyo@scientia.net>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange
References: <45B69D0C.8030501@scientia.net> <20070124000905.3a7b053d@localhost.localdomain>
In-Reply-To: <20070124000905.3a7b053d@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------050504000500000306060601"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050504000500000306060601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Alan wrote:
>> kernel:   Error: Illegal request -- (Sense key=0x05)
>> kernel:   Read of scrambled sector without authentication -- (asc=0x6f,
>> ascq=0x03)
>>     
>
> The disc is using digital rights management. If you are in a country that
> permits it you can use a dvd reader library with decss support, if not
> you'll have to either watch your disks on a system approved by the movie
> industry enforcers or commit a crime to read the disc.
>   
I knew of course about libdvdcss but I've never noticed before that the
kernel issues these error messages to the syslog.

So you say this is normal?! But the problem with ejecting isn't probably
normal.

Best wishes,
Chris.

--------------050504000500000306060601
Content-Type: text/x-vcard; charset=utf-8;
 name="calestyo.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="calestyo.vcf"

YmVnaW46dmNhcmQNCmZuOk1pdHRlcmVyLCBDaHJpc3RvcGggQW50b24NCm46TWl0dGVyZXI7
Q2hyaXN0b3BoIEFudG9uDQplbWFpbDtpbnRlcm5ldDpjYWxlc3R5b0BzY2llbnRpYS5uZXQN
CngtbW96aWxsYS1odG1sOlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------050504000500000306060601--
