Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZDDMpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZDDMpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZDDMpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:45:03 -0400
Received: from rtr.ca ([76.10.145.34]:33739 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZDDMpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:45:01 -0400
Message-ID: <49D7564A.9090409@rtr.ca>
Date: Sat, 04 Apr 2009 08:44:58 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org>
In-Reply-To: <49D66C0E.5090301@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>
> I've attached 'hdparm -I' in case anyone is curious.  It's from 
> newegg.com, so nothing NDA'd or sekrit.
>
> ATA device, with non-removable media
> 	Model Number:       G.SKILL 128GB SSD                       
> 	Serial Number:      MK0108480A545003B   
> 	Firmware Revision:  02.10104
> Standards:
> 	Used: ATA/ATAPI-7 T13 1532D revision 4a 
> 	Supported: 8 7 6 5 & some of 8
> Configuration:
> 	Logical		max	current
> 	cylinders	16383	16383
> 	heads		16	16
> 	sectors/track	63	63
> 	--
> 	CHS current addressable sectors:   16514064
> 	LBA    user addressable sectors:  250445824
> 	device size with M = 1024*1024:      122288 MBytes
> 	device size with M = 1000*1000:      128228 MBytes (128 GB)
..

That's odd.  I kind of expected to see the sector size,
cache size, and perhaps media rotation rate reported there..
Can you update your hdparm (sourceforge) and repost?

There might be other useful features of that drive,
which some of us are quite curious to know about!  :)

Thanks
