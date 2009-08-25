Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZHYBIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZHYBIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZHYBIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:08:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:61119 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZHYBIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,268,1249282800"; 
   d="scan'208";a="179688744"
Date: Mon, 24 Aug 2009 18:08:15 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: tiago.vignatti@nokia.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>
Subject: Re: [PATCH] vga: implements VGA arbitration on Linux
Message-ID: <20090824180815.0b5493bc@jbarnes-g45>
In-Reply-To: <20090816150936.GA18896@cachaca>
References: <1249969927-884-1-git-send-email-airlied@gmail.com>
	<20090811161746.7b8878aa@jbarnes-g45>
	<20090811162103.1b2a65c9@jbarnes-g45>
	<20090812073516.GB6453@cachaca>
	<20090812090214.2f5d3c4a@jbarnes-g45>
	<20090816150936.GA18896@cachaca>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009 18:09:36 +0300
Tiago Vignatti <tiago.vignatti@nokia.com> wrote:

> On Wed, Aug 12, 2009 at 06:02:14PM +0200, Jesse Barnes wrote:
> > On Wed, 12 Aug 2009 10:35:16 +0300
> > "Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com>
> > wrote:
> > > Okay, I can handle this documentation pretty easy. 
> > > 
> > > But honestly I'm not sure we (or some future developer) will use
> > > it. The header (include/linux/vgaarb.h) is already very nice
> > > documented. So, tell me what do you think Jesse.
> > 
> > As long as it's still accurate we may as well include it.
> 
> Here it comes attached. Please review, Jesse.

Applied to my linux-next branch, thanks.  If you want the other updates
you mentioned to land, you should send a patch for them as well.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
