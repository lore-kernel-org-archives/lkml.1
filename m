Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375Ab0ASNXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0ASNXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698Ab0ASNXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:23:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54849 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251Ab0ASNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:23:48 -0500
Date: Tue, 19 Jan 2010 13:23:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH v2] regulator: mc13783: consider Power Gates as digital
 regulators.
Message-ID: <20100119132346.GA17778@rakim.wolfsonmicro.main>
References: <1263901734.6669.28.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263901734.6669.28.camel@realization>
X-Cookie: Your fault -- core dumped
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 12:48:54PM +0100, Alberto Panizzo wrote:
> GPO regulators are digital outputs that can be enabled or disabled by a
> dedicated bit in mc13783 POWERMISC register.
> In this family can be count in also Power Gates (PWGT1 and 2): enabled by
> a dedicated pin a Power Gate is an hardware driven supply where the output
> (PWGTnDRV) follow this law:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
