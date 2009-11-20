Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZKTL2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZKTL2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZKTL2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:28:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34258 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751005AbZKTL2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:28:07 -0500
Date: Fri, 20 Nov 2009 11:28:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
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
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
Message-ID: <20091120112812.GC20236@rakim.wolfsonmicro.main>
References: <4B03DE53.6010007@nokia.com>
 <4B03DE9B.40800@nokia.com>
 <20091118133938.GE6592@rakim.wolfsonmicro.main>
 <20091118143609.GD2832@esdhcp037198.research.nokia.com>
 <20091118144145.GA16852@rakim.wolfsonmicro.main>
 <4B04EDE8.1010906@nokia.com>
 <20091119092412.GA4696@codecarver.research.nokia.com>
 <20091119103054.GC9763@rakim.wolfsonmicro.main>
 <20091120100633.GE3733@sortiz.org>
 <1258713145.3640.11.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258713145.3640.11.camel@odin>
X-Cookie: RELATIVES!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:32:25AM +0000, Liam Girdwood wrote:
> On Fri, 2009-11-20 at 11:06 +0100, Samuel Ortiz wrote:

> > Would you mind carrying this one with your twl4030-mfd branch ? It doesnt
> > apply cleanly to my tree due to the missing twl4030 patches from Peter.

> > Acked-by: Samuel Ortiz <sameo@linux.intel.com>

> Juha, this doesn't apply to regulator for-next either. Is it possible to
> split it out into a patch for mfd and a patch for regulator (against
> their for-next branches) ?

Either the existing twl4030-mfd branch or split patches work for me.
