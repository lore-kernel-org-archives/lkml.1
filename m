Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXD0FZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXD0FZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXD0FZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:25:21 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59055 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbXD0FYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:24:54 -0400
Date: Fri, 27 Apr 2007 07:24:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Phy Prabab <phyprabab@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Pin an IRQ to a particular CPU
In-Reply-To: <2fe399760704261815i428105d4qddc2648688e694bc@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704270724200.506@yvahk01.tjqt.qr>
References: <2fe399760704261815i428105d4qddc2648688e694bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello,
>
> In an effort to increase over all throughput of my Linux NFS file
> server, I thought about trying to force an IRQ, for the NIC, to be
> serviced by a particular CPU.  Is this possible?

http://lkml.org/lkml/2007/4/5/155


Jan
-- 
