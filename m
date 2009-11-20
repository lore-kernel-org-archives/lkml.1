Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbZKTKEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbZKTKEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZKTKEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:04:49 -0500
Received: from mga07.intel.com ([143.182.124.22]:25803 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbZKTKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:04:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="213796840"
Date: Fri, 20 Nov 2009 11:06:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
Message-ID: <20091120100633.GE3733@sortiz.org>
References: <4B03DE53.6010007@nokia.com>
 <4B03DE9B.40800@nokia.com>
 <20091118133938.GE6592@rakim.wolfsonmicro.main>
 <20091118143609.GD2832@esdhcp037198.research.nokia.com>
 <20091118144145.GA16852@rakim.wolfsonmicro.main>
 <4B04EDE8.1010906@nokia.com>
 <20091119092412.GA4696@codecarver.research.nokia.com>
 <20091119103054.GC9763@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119103054.GC9763@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Nov 19, 2009 at 10:30:54AM +0000, Mark Brown wrote:
> On Thu, Nov 19, 2009 at 11:24:12AM +0200, Peter 'p2' De Schrijver wrote:
> 
> > VINTANA2 can be turned off if MADC, audio and USB are not used. 
> 
> Sounds like it'd be useful to add regulator support for those drivers,
> then.
> 
> In any case, since nobody is using regulator_has_full_constraints()
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Would you mind carrying this one with your twl4030-mfd branch ? It doesnt
apply cleanly to my tree due to the missing twl4030 patches from Peter.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
