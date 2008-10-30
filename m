Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYJ3P1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYJ3P1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYJ3P1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:27:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:57686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYJ3P1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:27:22 -0400
Date: Thu, 30 Oct 2008 08:23:39 -0700
From: Greg KH <gregkh@suse.de>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Greg KH <greg@kroah.com>, Moritz Muehlenhoff <jmm@debian.org>,
       linux-kernel@vger.kernel.org
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081030152339.GA27095@suse.de>
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de> <20081028103337.a021e85d.rdunlap@xenotime.net> <20081028181402.GB4873@suse.de> <slrngghcgf.3do.jmm@inutil.org> <3aaafc130810291737i41716bd2r767150b47239b0a1@mail.gmail.com> <20081030014246.GA24081@kroah.com> <3aaafc130810300725l1911cd7ay1ba8d33e96c8424b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aaafc130810300725l1911cd7ay1ba8d33e96c8424b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:25:30AM -0400, J.R. Mauro wrote:
> Ok. I emailed a few of them. The ones I omitted either didn't have a
> clear homepage/maintainer, had already sent a patch to the kernel, or
> explicitly stated no intentions of going into mainline.

Which ones were in the last 2 categories?

> Maybe you could send me the Spreadsheet O' Drivers if you need more help?

Yeah, I think I'll move this to a google docs file or somehow merge it
with the information on the linuxdriverproject.org wiki.  Give me a few
days.

> I've also been wondering: should we contact the maintainers of the big
> distros and make them aware of staging and have them work with us to
> get whatever out-of-tree stuff they have more centralized? I don't
> know if it's a good idea, but it could be. And if it is, I have no
> idea where to start.

I've already looked at what the following distros include in their
kernel package:
	- Fedora
	- openSUSE
	- Ubuntu
so I have them on my list, and is where I took a number of the existing
staging drivers from.

If you could poke around other distro's kernels (like Mandrake and any
other you can think of) and find out what they include, that would e
great.

thanks,

greg k-h
