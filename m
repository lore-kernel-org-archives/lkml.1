Return-Path: <linux-kernel-owner+w=401wt.eu-S936524AbZDCUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936524AbZDCUFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZDCUFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:05:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41158 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZDCUFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:05:44 -0400
Message-ID: <49D66C0E.5090301@garzik.org>
Date: Fri, 03 Apr 2009 16:05:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------010400030400080701030505"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010400030400080701030505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> I didn't realize that Jeff had a non-Intel SSD. 
> THAT sure explains the huge drop-off. I do see Intel SSD's fluctuating 
> too, but the Intel ones tend to be _fairly_ stable.

Yeah, it's a no-name SSD.

I've attached 'hdparm -I' in case anyone is curious.  It's from 
newegg.com, so nothing NDA'd or sekrit.

	Jeff


--------------010400030400080701030505
Content-Type: text/plain;
 name="ssd-hdparm.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ssd-hdparm.txt"


/dev/sdb:

ATA device, with non-removable media
	Model Number:       G.SKILL 128GB SSD                       
	Serial Number:      MK0108480A545003B   
	Firmware Revision:  02.10104
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 4a 
	Supported: 8 7 6 5 & some of 8
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  250445824
	device size with M = 1024*1024:      122288 MBytes
	device size with M = 1000*1000:      128228 MBytes (128 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max = 1	Current = ?
	Recommended acoustic management value: 128, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	   *	Power Management feature set
	    	Write cache
	    	Look-ahead
	   *	Mandatory FLUSH_CACHE
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Host-initiated interface power management
	   *	Phy event counters
Checksum: correct

--------------010400030400080701030505--
