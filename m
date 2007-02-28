Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbXB1OWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbXB1OWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932714AbXB1OWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:22:53 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53488 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbXB1OWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:22:52 -0500
Date: Wed, 28 Feb 2007 08:20:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20 SATA error
In-reply-to: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no>
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <45E58FC7.7020102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> hello, 
> 
> Can someone tell me what this means?
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
> ata1.00: cmd 35/00:00:40:a6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 
> out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: port is slow to respond, please be patient (Status 0xd0)
> ata1: port failed to respond (30 secs, Status 0xd0)
> ata1: soft resetting port
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: configured for UDMA/100
> ata1: EH complete
> SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
> support DPO
> or FUA

Some command timed out, apparently. From this one can't easily say why. 
Please send full dmesg.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

