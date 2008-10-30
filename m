Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYJ3BsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYJ3BsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYJ3Brl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:47:41 -0400
Received: from kroah.org ([198.145.64.141]:41169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753673AbYJ3Brk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:47:40 -0400
Date: Wed, 29 Oct 2008 18:43:15 -0700
From: Greg KH <greg@kroah.com>
To: Moritz Muehlenhoff <jmm@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081030014315.GB24081@kroah.com>
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de> <20081028103337.a021e85d.rdunlap@xenotime.net> <20081028181402.GB4873@suse.de> <slrngghcgf.3do.jmm@inutil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrngghcgf.3do.jmm@inutil.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 07:57:19PM +0100, Moritz Muehlenhoff wrote:
> Greg KH wrote:
> > Of course, if someone doesn't want their code in the staging tree, I
> > will not add it, that's just being "nice".
> >
> > As for what I will not put into staging, right now I'm sticking with
> > drivers only, no filesystems (people have asked already).  I don't think
> > we have seen any drivers that I will not put into the staging tree yet.
> 
> Hi Greg,
> Great effort with staging, thanks a lot!
> 
> I've had a look at the out-of-tree kernel drivers currently present
> in Debian, maybe you want to merge some into staging. The Debian
> overview pages contain download links (the orig.tar.gz files):

Thanks for the summary.

(hint, next time, don't drop CC: addresses...)

greg k-h
