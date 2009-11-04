Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZKDNDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZKDNDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbZKDNDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:03:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:42286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbZKDNDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:03:53 -0500
Date: Wed, 4 Nov 2009 14:03:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
Cc: Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-10-28
In-Reply-To: <20091102211629.GA1322@ucw.cz>
Message-ID: <alpine.LRH.2.00.0911041403480.31913@twin.jikos.cz>
References: <1256886023.3555.5.camel@johannes.local> <20091030110616.GB6150@ff.dom.local> <20091030150223.GA2586@tuxdriver.com> <20091102091038.GA9044@elte.hu> <1257153807.3555.173.camel@johannes.local> <20091102100702.GA16963@elte.hu> <20091102170114.GE14046@tuxdriver.com>
 <efe7343f0911020932l21a570c8u9478568329d38e2c@mail.gmail.com> <20091102211629.GA1322@ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Pavel Machek wrote:

> > I've searched on my GMail archives and the only patch Bart has
> > provided so far for the rt2x00 project is this:
> > 
> > [PATCH] MAINTAINERS: rt2x00 list is moderated
> > 
> > Which, while technically correct, adds nothing to the project.
> > 
> > So, I will personally continue to ignore Bart's comments, regards and
> > rants, until he provides patches for rt2x00 that actually make the
> > driver better.
> 
> Well, he provided review feedback... he should be thanked for that,
> not flamed for it.

He has actually written real patches (and quite non-trivial both in amount 
and in functionality), see

	http://lkml.org/lkml/2009/11/3/372

But yes, he got flamed for this for some odd reason. I got the impression 
that the community around rt2x00 doesn't like (or understand) the way how 
opensource development happens.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

