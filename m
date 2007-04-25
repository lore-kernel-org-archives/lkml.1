Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXDYXQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXDYXQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXDYXQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:16:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:13197 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbXDYXQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:16:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,452,1170662400"; 
   d="scan'208";a="219425225"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PCI mmconfig support for Intel 915 bridges
Date: Wed, 25 Apr 2007 16:16:59 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>, linux-kernel@vger.kernel.org
References: <200701101853.04059.jbarnes@virtuousgeek.org> <200704251535.17528.jesse.barnes@intel.com> <20070425160737.37e684cf.akpm@linux-foundation.org>
In-Reply-To: <20070425160737.37e684cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251616.59558.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keep reading... 

On Wednesday, April 25, 2007 4:07 pm Andrew Morton wrote:
> On Wed, 25 Apr 2007 15:35:15 -0700 Jesse Barnes 
<jesse.barnes@intel.com> wrote:
> > I see the other mmconfig stuff is upstream now, can we get this
> > added too?  The Asus bug Olivier mentioned also appears to be
> > fixed, so this patch should be safe.
> >
> > Thanks,
> > Jesse
>
>   ^^^^^ is an evil top-poster!

Hey I wanted to let you see the original! :)

> > On Wednesday, January 10, 2007 6:53 pm Jesse Barnes wrote:
> > > This is a resend of the patch I sent earlier to Oliver.  It adds
> > > support for Intel 915 bridge chips to the new PCI MMConfig
> > > detection code.  Tested and works on my sole 915 based platform
> > > (a Toshiba laptop).  I added register masking per Oliver's
> > > suggestion, and moved the __init qualifier to after the 'static
> > > const char' to match Ogawa-san's recent cleanup patches.
> > >
> > > Over time we can probably associate more PCI IDs with this
> > > routine, since i915 family contains a few other chips.  But since
> > > I didn't have platforms to test such additions on, they're left
> > > out for now.
> > >
> > > Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
>
> Can we have a refresh, retest and resend please?

Sure.  I'll try to resend tomorrow or so.

Thanks,
Jesse
