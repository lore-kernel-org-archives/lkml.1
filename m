Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYK1MRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYK1MRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYK1MQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:16:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53028 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYK1MQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:16:50 -0500
Date: Fri, 28 Nov 2008 13:18:38 +0100
From: Pavel Machek <pavel@suse.cz>
To: Rob Landley <rob@landley.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: Document hadling of bad memory
Message-ID: <20081128121837.GB2834@elf.ucw.cz>
References: <20081126161521.GC1983@elf.ucw.cz> <200811280300.26969.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811280300.26969.rob@landley.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-11-28 03:00:26, Rob Landley wrote:
> On Wednesday 26 November 2008 10:15:21 Pavel Machek wrote:
> > Document how to deal with bad memory reported with memtest.
> ...
> > +BadRAM
> > +######
> > +BadRAM is the actively developed and available as kernel-patch
> > +here:  http://rick.vanrein.org/linux/badram/
> 
> So the patch isn't worth merging, but documentation about the out-of-tree 
> patch is worth merging?

Well, why not. The patch is unneccessary, but for the poor souls hit
by bad memory, one line pointer can help...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
