Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZCVTRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZCVTRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZCVTR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:17:27 -0400
Received: from mga05.intel.com ([192.55.52.89]:30386 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754587AbZCVTR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:17:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,403,1233561600"; 
   d="scan'208";a="441025814"
Date: Sun, 22 Mar 2009 20:19:35 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: dbrownell@users.sourceforge.net, OMAP <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch] twl4030-regulator: expose VPLL2
Message-ID: <20090322191935.GB2832@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <200903131754.54997.david-b@pacbell.net> <20090316155103.GJ16539@sirena.org.uk> <1237486426.6781.345.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237486426.6781.345.camel@vega.slimlogic.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 06:13:46PM +0000, Liam Girdwood wrote:
> On Mon, 2009-03-16 at 15:51 +0000, Mark Brown wrote:
> > On Fri, Mar 13, 2009 at 05:54:54PM -0700, David Brownell wrote:
> > > From: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > Add VPLL2 to the set of twl4030-family regulators exposed for
> > > use by various drivers.  It's commonly used to power the digital
> > > video outputs (e.g. LCD or DVI displays) on OMAP3 systems.
> > > 
> > > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Samuel, I've applied this to the regulator tree as the part that touches
> mfd is relatively minor and twl4030 specific (doesn't touch core).
Thanks a lot, and sorry for the late reply...
Feel free to add my Acked-by: if needed.

Cheers,
Samuel.

 
> Thanks
> 
> Liam
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
