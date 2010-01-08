Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158Ab0AHLnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0AHLnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552Ab0AHLnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:43:11 -0500
Received: from mga06.intel.com ([134.134.136.21]:28622 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786Ab0AHLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:43:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,241,1262592000"; 
   d="scan'208";a="585472014"
Date: Fri, 8 Jan 2010 12:44:43 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783
 before subsystems initialisation.
Message-ID: <20100108114442.GB23619@sortiz.org>
References: <1260808880.2022.98.camel@climbing-alby>
 <1260810776.2022.130.camel@climbing-alby>
 <1260811085.2022.135.camel@climbing-alby>
 <1261152746.3356.72.camel@climbing-alby>
 <20091219201816.GA28742@pengutronix.de>
 <1261316918.5224.15.camel@climbing-alby>
 <20091220184941.GA13294@pengutronix.de>
 <1261349401.5224.154.camel@climbing-alby>
 <1262949215.2050.19.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262949215.2050.19.camel@climbing-alby>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alberto,

On Fri, Jan 08, 2010 at 12:13:35PM +0100, Alberto Panizzo wrote:
> Samuel, although patch [1/4] is not a matter of .33 
> I think this one [2/4] can go to mainline in this subversion.
> 
> As submitted by Valentin Longchamp here:
> 
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/71128/focus=71127
> 
> this patch, Acked by Uwe, fix a little regression in mc13783-core.
Right, I'll push that upstream soon.

Cheers,
Samuel.


> Best Regards,
> Alberto!
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
