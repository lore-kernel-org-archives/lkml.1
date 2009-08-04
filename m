Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZHDOFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZHDOFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZHDOFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:05:18 -0400
Received: from mga07.intel.com ([143.182.124.22]:27368 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753181AbZHDOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,321,1246863600"; 
   d="scan'208";a="172126570"
Date: Tue, 4 Aug 2009 16:07:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Jean Delvare <khali@linux-fr.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 0/22] WM831x drivers
Message-ID: <20090804140716.GD8601@sortiz.org>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main> <20090804113528.GB8601@sortiz.org> <1249386249.4248.159.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249386249.4248.159.camel@vega.slimlogic.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam

On Tue, Aug 04, 2009 at 12:44:09PM +0100, Liam Girdwood wrote:
> On Tue, 2009-08-04 at 13:35 +0200, Samuel Ortiz wrote:
> > Hi Mark,
> > 
> > On Mon, Jul 27, 2009 at 02:45:27PM +0100, Mark Brown wrote:
> > > The following patch series adds initial support for the WM813x series of
> > > PMICs.
> > > 
> > > Since these devices have functionality that crosses many subsystems the
> > > patches cross many kernel trees.  For clarity I'm presenting this
> > > initial submission as a single series but I have endeavoured to split
> > > things up so that the patches can be applied separately to the various
> > > subsystems.  In order to avoid merge issues as patches are applied the
> > > platform data for the devices is included in the core patches.
> > > 
> > > Due to Kconfig and Makefile collisons I've also included the patch adding
> > > hwmon support for the WM835x series of PMICs to the series.  Other than
> > > the build system updates there is no interdependence between those two
> > > patches.
> > I applied patches [1-8], the gpio one, the 2 hwmon ones and the input one.
> > I'll now wait for some more feedback for the remaining patches.
> > 
> 
> Regulator patches :-
> 
> Acked-by Liam Girdwood <lrg@slimlogic.co.uk>
Thanks Liam, I applied all 5 of them to my for-next branch

Cheers,
Samuel.


> Thanks
> 
> Liam
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
