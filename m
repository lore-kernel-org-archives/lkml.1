Return-Path: <linux-kernel-owner+w=401wt.eu-S2992715AbXDYLax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992715AbXDYLax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992704AbXDYLax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:30:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33720 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992715AbXDYLaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:30:52 -0400
Date: Wed, 25 Apr 2007 13:31:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425113102.GU3468@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214909.GD3468@stusta.de> <20070425040605.6d6b4a82.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425040605.6d6b4a82.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:06:05AM -0700, Andrew Morton wrote:
> On Mon, 23 Apr 2007 23:49:09 +0200 Adrian Bunk <bunk@stusta.de> wrote:
>...
> > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
> >              workaround: CONFIG_FB_BACKLIGHT=n
> > References : http://lkml.org/lkml/2007/3/13/3
> > Submitter  : Dave Jones <davej@redhat.com>
> > Caused-By  : PCI merge
> >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
> > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
> >              Rafael J. Wysocki <rjw@sisk.pl>
> >              Antonino A. Daplas <adaplas@gmail.com>
> > Status     : unknown
> 
> Is this related to the problems Jeremy has been looking at?
>...

Dave and Jeremy hran into similar looking but most likely different 
problems.

For Jeremy -rc7 is working fine, but for Dave it doesn't.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

