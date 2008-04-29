Return-Path: <linux-kernel-owner+w=401wt.eu-S1763030AbYD2U22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763030AbYD2U22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbYD2U2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:28:06 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:51013 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762774AbYD2U2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:28:05 -0400
Date: Tue, 29 Apr 2008 16:28:03 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: [2.6.25] lpfc driver problem
Message-ID: <alpine.DEB.1.10.0804291625330.31652@mtl.rackplans.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello

I'm getting the following error when trying to load the lpfc driver.  This 
is a new install so I have no idea if this is a regression or not.

dmesg output:
Emulex LightPulse Fibre Channel SCSI driver 8.2.5
Copyright(c) 2004-2008 Emulex.  All rights reserved.
scsi2 :  on PCI bus 02 device 50 irq 24
lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
x400000, FW Data: A8 x0 AC x0
lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
x400000, FW Data: A8 x0 AC x0

Card is:
02:0a.0 Fibre Channel: Emulex Corporation LP8000 Fibre Channel Host 
Adapter (rev 02)
02:0a.0 0c04: 10df:f800 (rev 02)


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
