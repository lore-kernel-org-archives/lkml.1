Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXEITxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXEITxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXEITxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:53:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46795 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXEITxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:53:35 -0400
Message-ID: <464226BD.8000602@garzik.org>
Date: Wed, 09 May 2007 15:53:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Gerhard Mack <gmack@innerfire.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] SATA freeze
References: <Pine.LNX.4.64.0705091453310.18441@mtl.rackplans.net>
In-Reply-To: <Pine.LNX.4.64.0705091453310.18441@mtl.rackplans.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> May  9 14:51:35 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 0x0 
> SErr 0x1800000 action 0x2 frozen
> May  9 14:51:35 mgerhard kernel: ata1.00: cmd 
> 35/00:00:80:6d:c8/00:04:09:00:00/e0 tag 0 cdb 0x0 data 524288 out
> May  9 14:51:35 mgerhard kernel:          res 
> 40/00:c8:68:65:c8/84:00:09:00:00/e0 Emask 0x4 (timeout)
> May  9 14:51:42 mgerhard kernel: ata1: port is slow to respond, please be 
> patient (Status 0xd0)
> 
> Anything I can do to figgure out what's causing this?

Provide full lspci, dmesg, kernel config?

	Jeff



