Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYJEFKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYJEFKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 01:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYJEFKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 01:10:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYJEFKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 01:10:13 -0400
Date: Sat, 4 Oct 2008 22:08:16 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, pchen@nvidia.com, stable@kernel.org
Subject: Re: patch sata_nv-disable-hardreset-for-generic.patch added to
	2.6.26-stable tree
Message-ID: <20081005050816.GA3739@suse.de>
References: <20081001234424.C72C114543E5@imap.suse.de> <200810041827.04721.s.L-H@gmx.de> <20081005025401.GA22549@suse.de> <48E83272.7040709@kernel.org> <20081005034800.GA7802@suse.de> <48E84608.5080108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E84608.5080108@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 01:43:52PM +0900, Tejun Heo wrote:
> Greg KH wrote:
> >> It's currently a mess.  Please take a look at the following message for
> >> the whole story.
> >>
> >>   http://article.gmane.org/gmane.linux.ide/34942
> >>
> >> It's interesting how they fixed hardreset of the chipset step-by-step. :-(
> > 
> > Ick, you are right, what a mess.
> > 
> > Do you want that patch in 2.6.26-stable now?  Or just don't worry about
> > it?
> 
> 2.6.26-stable should be fixed but given the series of breakages I
> wanna be a bit cautious before proceeding.  Just give me a few more
> days so that I can confirm the posted patch fixes the problem for both
> generic and nf2/3 flavors.  I'll forward the final patch against
> -stable to you then.

Sounds good to me.

thanks,

greg k-h
