Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZHFXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZHFXhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZHFXh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:37:26 -0400
Received: from kroah.org ([198.145.64.141]:55080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbZHFXh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:37:26 -0400
Date: Thu, 6 Aug 2009 16:32:42 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, charles.f.johnson@intel.com
Subject: Re: [PATCH] Restricted access regions register driver revision 2
 (moving to staging)
Message-ID: <20090806233242.GA29345@kroah.com>
References: <1249597272-16185-1-git-send-email-mark.a.allyn@intel.com>
 <20090806224848.GA15537@kroah.com>
 <20090807002250.67807c57@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807002250.67807c57@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 12:22:50AM +0100, Alan Cox wrote:
> On Thu, 6 Aug 2009 15:48:48 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Aug 06, 2009 at 03:21:12PM -0700, Mark Allyn wrote:
> > >  Upstream revision 3 of the restricted access memory registry
> > >  kernel driver;
> > > 
> > >  Moving to staging per Alan Cox's suggestion
> > 
> > Heh, Alan just sent me this already in his series of 13 patches.  Do you
> > have any objection to that version, it looks to be the same as this one.
> 
> Got some more for you as well shortly. Seem to be up to 22 ;)

Heh, that's common for staging drivers, there's lots of work to do there
;)

thanks,

greg k-h
