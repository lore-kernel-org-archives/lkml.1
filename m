Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbXEISzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbXEISzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbXEISyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:54:54 -0400
Received: from [69.90.0.18] ([69.90.0.18]:36654 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbXEISyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:54:53 -0400
Date: Wed, 9 May 2007 14:54:49 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: [2.6.21.1] SATA freeze
Message-ID: <Pine.LNX.4.64.0705091453310.18441@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

May  9 14:51:35 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 0x0 
SErr 0x1800000 action 0x2 frozen
May  9 14:51:35 mgerhard kernel: ata1.00: cmd 
35/00:00:80:6d:c8/00:04:09:00:00/e0 tag 0 cdb 0x0 data 524288 out
May  9 14:51:35 mgerhard kernel:          res 
40/00:c8:68:65:c8/84:00:09:00:00/e0 Emask 0x4 (timeout)
May  9 14:51:42 mgerhard kernel: ata1: port is slow to respond, please be 
patient (Status 0xd0)

Anything I can do to figgure out what's causing this?

	Gerhard
 

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
