Return-Path: <linux-kernel-owner+w=401wt.eu-S1161184AbXAZTHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161184AbXAZTHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161181AbXAZTHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:07:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:50650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161180AbXAZTHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:07:42 -0500
Date: Fri, 26 Jan 2007 11:06:38 -0800
From: Greg KH <greg@kroah.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: xiphmont@xiph.org, Pierre Ossman <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       Lennart Poettering <lennart@poettering.net>, perex@suse.cz
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Message-ID: <20070126190638.GA31453@kroah.com>
References: <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com> <s5h1wljuf2f.wl%tiwai@suse.de> <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com> <20070125194933.GA27857@kroah.com> <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com> <20070125215943.GC3126@kroah.com> <806dafc20701260253r145fee43kc6db1ca6de1ab3e6@mail.gmail.com> <s5hejpivwwg.wl%tiwai@suse.de> <20070126180457.GA29543@kroah.com> <s5hd5511w81.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hd5511w81.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 07:25:34PM +0100, Takashi Iwai wrote:
> Greg, feel free to pick it up to your tree for pushing.   Since this
> patch conflicts with the development tree of ALSA mm branch, it'd be
> even harder to push from ALSA tree, unfortuantely...
> 
> Of course, it'd be safer after confirming that the patch works indeed.
> (My brief tests show good results, though.)

Ok, I'll do it through my trees, but I'll wait for Monty to finish
building and testing.

/me hands Monty a copy of distcc and ccache :)

thanks,

greg k-h
