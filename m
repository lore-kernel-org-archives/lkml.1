Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYDUDGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYDUDGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYDUDGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:06:13 -0400
Received: from sandeen.net ([209.173.210.139]:19981 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYDUDGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:06:12 -0400
Message-ID: <480C04A3.3000600@sandeen.net>
Date: Sun, 20 Apr 2008 22:06:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, Daniel Hazelton <dhazelton@enter.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org>	<20080420104444.GI1595@cs181133002.pp.htv.fi>	<87y778aezh.fsf@basil.nowhere.org>	<200804201144.33308.dhazelton@enter.net>	<480B7CB2.3080002@firstfloor.org>	<20080420114845.77bf3fed@laptopd505.fenrus.org>	<480BA12A.4000307@firstfloor.org> <20080420153318.553e5d2d@laptopd505.fenrus.org>
In-Reply-To: <20080420153318.553e5d2d@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> Google scores:
> 
> 1-order allocation failed		54000 pages
> do_IRQ: stack overflow			4560 pages

with quotes for exact matches:

"1-order allocation failed"	790 pages
"do_IRQ: stack overflow"	1,880 pages

http://www.google.com/search?q=%221-order+allocation+failed%22
http://www.google.com/search?q=%22do_IRQ%3A+stack+overflow%22

-Eric
