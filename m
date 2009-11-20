Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZKTMVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZKTMVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZKTMVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:21:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:63552 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZKTMVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:21:43 -0500
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
In-Reply-To: <20091120112812.GC20236@rakim.wolfsonmicro.main>
References: <4B03DE53.6010007@nokia.com> <4B03DE9B.40800@nokia.com>
	 <20091118133938.GE6592@rakim.wolfsonmicro.main>
	 <20091118143609.GD2832@esdhcp037198.research.nokia.com>
	 <20091118144145.GA16852@rakim.wolfsonmicro.main>
	 <4B04EDE8.1010906@nokia.com>
	 <20091119092412.GA4696@codecarver.research.nokia.com>
	 <20091119103054.GC9763@rakim.wolfsonmicro.main>
	 <20091120100633.GE3733@sortiz.org> <1258713145.3640.11.camel@odin>
	 <20091120112812.GC20236@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 12:21:43 +0000
Message-ID: <1258719703.3640.41.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 11:28 +0000, Mark Brown wrote:
> On Fri, Nov 20, 2009 at 10:32:25AM +0000, Liam Girdwood wrote:
> > On Fri, 2009-11-20 at 11:06 +0100, Samuel Ortiz wrote:
> 
> > > Would you mind carrying this one with your twl4030-mfd branch ? It doesnt
> > > apply cleanly to my tree due to the missing twl4030 patches from Peter.
> 
> > > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> > Juha, this doesn't apply to regulator for-next either. Is it possible to
> > split it out into a patch for mfd and a patch for regulator (against
> > their for-next branches) ?
> 
> Either the existing twl4030-mfd branch or split patches work for me.

What's the upstream path for your twl4030-mfd ASoC branch ? 

Regulator + mfd patches either go upstream via the regulator or mfd
repositories.  

Liam

