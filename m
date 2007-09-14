Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbXINO1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbXINO1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXINO1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:27:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48137 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXINO1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:27:41 -0400
Date: Fri, 14 Sep 2007 16:26:41 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070914162641.197913c2@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0709131706100.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu>
	<Pine.LNX.4.64.0709120242040.1817@scrub.home>
	<20070913075258.GA9173@elte.hu>
	<Pine.LNX.4.64.0709131419170.1817@scrub.home>
	<20070913142842.GA26016@elte.hu>
	<Pine.LNX.4.64.0709131706100.1817@scrub.home>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 18:50:12 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:
> > You never directly replied to these pretty explicit requests, all
> > you did was this side remark 5 days later in one of your patch 
> > announcements:
> 
> This is ridiculous, I asked you multiple times to explain to me some
> of the differences relative to CFS as response to the splitup
> requests. Not once did you react, you didn't even ask what I'd like
> to know specifically.

Roman,

this is... a strange comment. It almost sounds like you were holding
the splitup hostage depending on some other thing happening.... that's
not a good attitude in my book. Having big-blob patches that do many
things at the same time leads to them being impossible to apply. Linux
works by having smaller incrementals. You know that; you've been around
for a long time.

Complaining that someone finally did splitup work after you refused,
and even puts credit in for you... that's beyond my comprehension.
Sorry.

