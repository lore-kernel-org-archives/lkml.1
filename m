Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbXA3Uj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbXA3Uj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXA3Uj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:39:26 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51069 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751422AbXA3UjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:39:25 -0500
Date: Tue, 30 Jan 2007 21:39:33 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Mike Houston <mikeserv@bmts.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How many people are using 2.6.16?
Message-ID: <20070130203933.GJ3754@stusta.de>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com> <20070129221300.GC19422@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129221300.GC19422@brong.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 09:13:00AM +1100, Bron Gondwana wrote:
> On Mon, Jan 29, 2007 at 04:04:48PM -0500, Mike Houston wrote:
> > On Mon, 29 Jan 2007 15:30:00 -0500
> > Chuck Ebbert <cebbert@redhat.com> wrote:
> > 
> > > Is there any way to estimate the size of the user base for 2.6.16?
> > > 
> > > e.g. how many downloads does it get?
> > 
> > I've often wondered that myself, as I'm concerned for it to continue
> > to be maintained. I'm very appreciative of what Adrian is doing with
> > it. (Thanks!)
> 
> We're still running 2.6.16 kernels on a bunch of machines, though 2.6.19
> has been looking pretty nice on the couple of machines that are testing
> it.  2.6.17 and 2.6.18 felt less stable.
> 
> We do a lot of Cyrus which does a lot of MMAP - and we also use the 
> Areca driver - which are both strong reasons to move to 2.6.19.2, but
> if the MMAP fix was ported back to 2.6.16 we might consider staying
> there instead.

Please correct me if I'm wrong, but as far as I understand the problem
the mmap bug was introduced in 2.6.19.

> Bron.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

