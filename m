Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZKIIxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZKIIxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZKIIxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:53:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40045 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbZKIIxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:53:22 -0500
Date: Mon, 9 Nov 2009 09:53:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Rik van Riel <riel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net, jack@suse.cz
Subject: periodic fsck was Re: [patch] ext2/3: document conditions when
 reliable operation is possible
Message-ID: <20091109085318.GE4818@elf.ucw.cz>
References: <20090824223915.GI17684@mit.edu>
 <20090824230036.GK29763@elf.ucw.cz>
 <4A932B18.1020209@redhat.com>
 <20090825093414.GB15563@elf.ucw.cz>
 <4A94ACDF.30405@redhat.com>
 <20090826111751.GC26595@elf.ucw.cz>
 <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm>
 <20090826131028.GB1370@ucw.cz>
 <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
 <20090826180248.GB6997@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826180248.GB6997@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-26 14:02:48, Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 06:43:24AM -0700, david@lang.hm wrote:
> >>>
> >>> as the ext3 authors have stated many times over the years, you still need
> >>> to run fsck periodicly anyway.
> >>
> >> Where is that documented?
> >
> > linux-kernel mailing list archives.
> 
> Probably from some 6-8 years ago, in e-mail postings that I made.  My
> argument has always been that PC-class hardware is crap, and it's a

Well, in SUSE11-or-so, distro stopped period fscks, silently :-(. I
believed that it was really bad idea at that point, but because I
could not find piece of documentation recommending them, I lost the
argument.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
