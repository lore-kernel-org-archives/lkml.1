Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZKDQfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZKDQfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbZKDQfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:35:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:53765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941AbZKDQfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:35:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,680,1249282800"; 
   d="scan'208";a="464302242"
Date: Wed, 4 Nov 2009 17:36:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>, alsa-devel@alsa-project.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       tony@atomide.com
Subject: Re: [PATCH 0/4 v2] ASoC/MFD/OMAP: TWL4030: APLL_CTL handling change
Message-ID: <20091104163655.GG3607@sortiz.org>
References: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
 <20091104102040.GA25922@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104102040.GA25922@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Nov 04, 2009 at 10:20:41AM +0000, Mark Brown wrote:
> On Wed, Nov 04, 2009 at 09:58:16AM +0200, Peter Ujfalusi wrote:
> 
> > The following series changes the way how the APLL_CTL register is handled by
> > the twl4030 codec related drivers.
> 
> I'm OK with this but I'll wait for acks from Tony and Samuel before
> applying.
You can add my Acked-by: Samuel Ortiz <sameo@linux.intel.com> to the 2 MFD
patches. Peter: thanks for the patches, and Mark: thanks for taking them :)

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
