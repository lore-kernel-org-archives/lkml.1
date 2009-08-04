Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZHDLoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZHDLoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZHDLoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:44:16 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:42063 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZHDLoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:44:15 -0400
Subject: Re: [PATCH 0/22] WM831x drivers
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
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
In-Reply-To: <20090804113528.GB8601@sortiz.org>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
	 <20090804113528.GB8601@sortiz.org>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 12:44:09 +0100
Message-Id: <1249386249.4248.159.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 13:35 +0200, Samuel Ortiz wrote:
> Hi Mark,
> 
> On Mon, Jul 27, 2009 at 02:45:27PM +0100, Mark Brown wrote:
> > The following patch series adds initial support for the WM813x series of
> > PMICs.
> > 
> > Since these devices have functionality that crosses many subsystems the
> > patches cross many kernel trees.  For clarity I'm presenting this
> > initial submission as a single series but I have endeavoured to split
> > things up so that the patches can be applied separately to the various
> > subsystems.  In order to avoid merge issues as patches are applied the
> > platform data for the devices is included in the core patches.
> > 
> > Due to Kconfig and Makefile collisons I've also included the patch adding
> > hwmon support for the WM835x series of PMICs to the series.  Other than
> > the build system updates there is no interdependence between those two
> > patches.
> I applied patches [1-8], the gpio one, the 2 hwmon ones and the input one.
> I'll now wait for some more feedback for the remaining patches.
> 

Regulator patches :-

Acked-by Liam Girdwood <lrg@slimlogic.co.uk>

Thanks

Liam


