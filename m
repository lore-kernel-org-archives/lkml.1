Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZKSKav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZKSKav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbZKSKav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:30:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59137 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758132AbZKSKau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:30:50 -0500
Date: Thu, 19 Nov 2009 10:30:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Cc: "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
Message-ID: <20091119103054.GC9763@rakim.wolfsonmicro.main>
References: <4B03DE53.6010007@nokia.com>
 <4B03DE9B.40800@nokia.com>
 <20091118133938.GE6592@rakim.wolfsonmicro.main>
 <20091118143609.GD2832@esdhcp037198.research.nokia.com>
 <20091118144145.GA16852@rakim.wolfsonmicro.main>
 <4B04EDE8.1010906@nokia.com>
 <20091119092412.GA4696@codecarver.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119092412.GA4696@codecarver.research.nokia.com>
X-Cookie: Do you like "TENDER VITTLES"?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 11:24:12AM +0200, Peter 'p2' De Schrijver wrote:

> VINTANA2 can be turned off if MADC, audio and USB are not used. 

Sounds like it'd be useful to add regulator support for those drivers,
then.

In any case, since nobody is using regulator_has_full_constraints()

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
