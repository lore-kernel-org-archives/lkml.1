Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbXEDLxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbXEDLxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXEDLxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:53:35 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52287 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbXEDLxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:53:34 -0400
Date: Fri, 4 May 2007 13:51:38 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Wander Winkelhorst <w.winkelhorst@gmail.com>
cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <5699f8f00705040436u63c5ab38g1054001eccc596e7@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705041349390.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
 <5699f8f00705040436u63c5ab38g1054001eccc596e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 13:36, Wander Winkelhorst wrote:
>
> Hi,
>
> I also have the same problem. Except in my case the box is stable
> for a couple of hours before it locks up hard. I did some digging
> around, and from what I found on the internet, it seems that having
> busmaster DMA devices causes this problem.
>
Does it happen for you when you use the 'powersave' governor
(always keeping the lowest frequency)?


Jan
-- 
