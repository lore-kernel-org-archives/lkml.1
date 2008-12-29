Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYL2GE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYL2GE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 01:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYL2GEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 01:04:50 -0500
Received: from 1wt.eu ([62.212.114.60]:1440 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYL2GEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 01:04:49 -0500
Date: Mon, 29 Dec 2008 07:04:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: Igor Podlesny <for.poige+linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest stable version of the Linux kernel is".
Message-ID: <20081229060445.GD6800@1wt.eu>
References: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 12:39:55PM +0700, Igor Podlesny wrote:
> Actually that's either a mistake or I don't know what you guys call "a
> stable version".
> 
> Since 2.6.24 there're serious regressions in all the following
> "stable" releases. Both my own experience + http://www.kerneloops.org/
> proves that.
> 
> Just to bring in some examples:
> 
> -- using 2.6.25.x I started to notice "oops"es in dmesg (what hadn't
> been happening for a long time).
> 
> -- since 2.6.26 mine desktop system can't go suspend or hibernate. It
> tries, but immediately returns from that trying.
> 
> -- Copying several rather big files (~ 25--45 GiB) from XFS on LVM-2
> on MDraid partition to another one, I had the system rebooted both
> with 2.6.28 and 2.6.27.10 (accomplished using 2.6.24.7-rt(sic!)25). As
> you probably understand, that's the case you even can't trace where's
> the problem, at least on a desktop with GUI, not on server with plain
> text display. Although, I'm afraid even text display wouldn't had a
> chance to show anything, tracing that problem.
> 
> So, I don't feel Linux is stable since 2.6.24. Do you?

Well, I won't say that I find them 100% rock solid, but you seem to be
able to reproduce a lot of serious issues. Have you filed bug reports
to get them fixed ? You cannot expect people to fix bugs they're not
aware of !

Also it would be a good idea to get all those issues fixed soon, because
2.6.27-stable will be maintained for a long time.

Willy

