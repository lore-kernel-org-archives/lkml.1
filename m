Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264Ab0AVUsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0AVUsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220Ab0AVUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:48:12 -0500
Received: from kroah.org ([198.145.64.141]:47369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0AVUsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:48:10 -0500
Date: Fri, 22 Jan 2010 12:35:45 -0800
From: Greg KH <greg@kroah.com>
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>
Subject: Re: Introduction to rar_register patch set of 5 patches
Message-ID: <20100122203545.GB15734@kroah.com>
References: <1264182811-28933-1-git-send-email-mark.a.allyn@intel.com>
 <20100122102308.bb17fd1a.rdunlap@xenotime.net>
 <20100122183322.GA9512@kroah.com>
 <8A0E4C92AE2D6D40AF99653191DA323160F7A280D1@rrsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA323160F7A280D1@rrsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Fri, Jan 22, 2010 at 12:59:50PM -0700, Allyn, Mark A wrote:
> Greg:
> 
> Just to be clear; then only the overall description of RAR should be
> in the cover email?

Yes, consider that something that introduces the series, but will be
deleted and never seen again.  The actual description needs to be in the
patches themselves, as that is what is going to be committed to the
tree, and that information will show up in the changelog for everyone to
look at for forever.

> Perhaps I over reacted to you earlier comment that each patch had too
> much, so I moved everything to the intro email. 
> 
> I will re-submit with the description of each patch in each patch, but
> I will still list the patches in the intro.

Sure, that's fine.

thanks,

greg k-h
