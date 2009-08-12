Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZHLPy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZHLPy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZHLPy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:54:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:3639 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZHLPy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,368,1246863600"; 
   d="scan'208";a="716170116"
Date: Wed, 12 Aug 2009 08:54:25 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "tiago.vignatti@nokia.com" <tiago.vignatti@nokia.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dave Airlie <airlied@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>
Subject: Re: [PATCH] vga: implements VGA arbitration on Linux
Message-ID: <20090812085425.76eeba04@jbarnes-g45>
In-Reply-To: <20090812072437.GA6453@cachaca>
References: <1249969927-884-1-git-send-email-airlied@gmail.com>
	<20090811161746.7b8878aa@jbarnes-g45>
	<1250059688.15143.6.camel@pasglop>
	<20090812072437.GA6453@cachaca>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 00:24:37 -0700
"Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com> wrote:

> On Wed, Aug 12, 2009 at 08:48:08AM +0200, Benjamin Herrenschmidt
> wrote:
> > On Tue, 2009-08-11 at 16:17 -0700, Jesse Barnes wrote:
> > 
> > > Ok, applied this to my linux-next branch, but I'd like to get
> > > Ben's s-o-b before pushing it to Linus.
> > 
> > Well, S-O-B is if the code went through my hands... though in this
> > case I wrote the original version so I suppose it did :-) An ack
> > for sure.
> > 
> > Let me have a look, I'll come back to you asap.
> 
> Ohh, I feel more comfortable if the patches come with Ben's
> authorship. Please do it Dave because it makes more sense (and S-O-B
> by me).

Ok I amended the patch to make Ben the author, with s-o-bs from Dave
and you since you both worked on the code.

Dave, do you want me to apply the DRM patch too, just to avoid having a
dependency?  You could also pull my tree into yours; let me know if you
do and I won't do anymore rebases before sending Linus a pull request.

-- 
Jesse Barnes, Intel Open Source Technology Center
