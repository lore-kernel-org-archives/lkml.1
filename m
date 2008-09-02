Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYIBPZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYIBPZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYIBPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:25:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3169 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbYIBPZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:25:34 -0400
Date: Tue, 2 Sep 2008 17:25:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
Message-ID: <20080902152517.GA4758@ucw.cz>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828200120.GA16462@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So, after all the fuss, here's the state-of-the-art standard-compliant
> > cloud-computing web-3.0-beta web page for OSS emulation using CUSE.
> > 
> >   http://userweb.kernel.org/~tj/ossp/
> > 
> > It works pretty well here.  :-)
> 
> Sorry for being destructive, but 6 years after ALSA went into the
> kernel we are slightly approaching the point where all applications 
> support ALSA.

Did ALSA reach a point where you can support new cards by just
updating the kernel?

I kind of like /dev/dsp interface... and don't see why simple sound
apps should be linked to libalsa... I used to record and play sounds
from shell by cat /dev/dsp...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
