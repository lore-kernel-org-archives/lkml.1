Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbYKYIKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbYKYIKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYKYIKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:10:31 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:57603 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYKYIKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:10:30 -0500
Date: Tue, 25 Nov 2008 09:11:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, ariveira@gmail.com, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de
Subject: Re: [PATCH] ncurses based config V2
Message-ID: <20081125081153.GA12275@uranus.ravnborg.org>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com> <1220603220-17090-1-git-send-email-nir@tzachar.com> <20080905195930.GA27913@1wt.eu> <20081124184428.GA17085@uranus.ravnborg.org> <9b2db90b0811250001k6e0c609frca073f3221a3e8ed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2db90b0811250001k6e0c609frca073f3221a3e8ed@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nir.

> >>         [ ]   (U)TS namespace
> >>         [ ]   (I)PC namespace
> >>         [ ]   (U)ser namespace (EXPERIMENTAL)
> >>         [ ]   (P)ID Namespaces (EXPERIMENTAL)
> >
> > This looks like some ancient stuff and it must be a better way to
> > show the short-cuts.
> 
> This was the best I could come up with, as ncurses does not let you
> use color attributed for menu items. I'll try a different scheme,
> where the first capitalized letter is the shortcut. What do u say?

Better than the above - let me see it in action and I will judge.
I had preferred something with a colored highlight - but if ncurses
do not support that then I think first catital letter i ok.

Alternative is to use first letter in the prompt and accept the
ambiguity.

> > I would really appreciate if you could look into the above issues.
> > If you do a repost with this fixed I will try to do a proper review,
> > including code-review next time.
> 
> Sure. I'll have a patch ready in a few days.

Great - loks forward to see it.

	Sam
