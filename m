Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbXD0F0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbXD0F0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXD0F0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:26:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59865 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbXD0F0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:26:09 -0400
Date: Fri, 27 Apr 2007 07:25:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Phy Prabab <phyprabab@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Pin an IRQ to a particular CPU
In-Reply-To: <2fe399760704261815i428105d4qddc2648688e694bc@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704270724470.506@yvahk01.tjqt.qr>
References: <2fe399760704261815i428105d4qddc2648688e694bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 26 2007 18:15, Phy Prabab wrote:
> Hello,
>
> In an effort to increase over all throughput of my Linux NFS file
> server, I thought about trying to force an IRQ, for the NIC, to be
> serviced by a particular CPU.  Is this possible?

Sorry, too early in the morning :)
It is definitely possible, since that is what irqbalance does.
(Not that I know the exact details right now...)
the other URL I posted might give some useful hints too, though.


Jan
-- 
