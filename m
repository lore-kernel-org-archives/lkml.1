Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXB1MkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXB1MkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXB1MkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:40:25 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:43653 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXB1MkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:40:24 -0500
Date: Wed, 28 Feb 2007 07:40:23 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 SATA error
Message-ID: <Pine.LNX.4.64.0702280739510.21113@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello, 

Can someone tell me what this means?
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:40:a6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
support DPO
or FUA


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
