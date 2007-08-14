Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbXHNSo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbXHNSo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933922AbXHNSnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:43:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4812 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbXHNSni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:43:38 -0400
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
	Suspend, aka swsusp):
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
	 <200708132338.25925.rjw@sisk.pl> <20070814070528.GA2903@elf.ucw.cz>
	 <200708141937.06676.rjw@sisk.pl> <1187114231.32555.105.camel@localhost>
	 <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 11:42:36 -0700
Message-Id: <1187116957.32555.136.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 11:15 -0700, Linus Torvalds wrote:
> Quite frankly, I think the MAINTAINERS file gets a whole lot uglier this 
> way.

Me too.
Chopping up the current file is simple.

How about keeping the whole thing in git?
Please look at thread:
[PATCH] [1/2many] - Find the maintainer(s) for a patch - scripts/get_maintainer.pl

> In other words, it would be much better to just have per-file markers, 
> along with some per-subdirectory stuff or similar.

Perhaps a single top-level MAINTAINERS subdirectory with
500+ files or MAINTAINERS per subdirectory.

Doesn't matter to me.

I'd prefer no per-file external markers,
nor embedded per-file keywords.

