Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZBFOIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZBFOIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZBFOI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:08:28 -0500
Received: from mga10.intel.com ([192.55.52.92]:8582 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753180AbZBFOI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:08:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="663434206"
Date: Fri, 6 Feb 2009 15:10:52 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] WM8350 updates
Message-ID: <20090206141051.GJ3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20090205181235.GA4851@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205181235.GA4851@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:12:35PM +0000, Mark Brown wrote:
> I saw you had applied most of the outstanding patches for the WM8350
> except for these two so I figured they may have been lost in the shuffle
> and am resending them:
Ok, I got them now. Will apply, thanks.

Cheers,
Samuel.

 
> The following changes since commit e3d31e08fa03bb896ddea609dc5a703cf072babc:
>   Mark Brown (1):
>         mfd: Use bulk read to fill WM8350 register cache
> 
> are available in the git repository at:
> 
>   git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-sameo
> 
> Mark Brown (2):
>       mfd: Support active high IRQs on WM835x
>       mfd: Ensure all WM8350 IRQs are masked at startup
> 
>  drivers/mfd/wm8350-core.c       |   23 ++++++++++++++++++++++-
>  include/linux/mfd/wm8350/core.h |    2 ++
>  2 files changed, 24 insertions(+), 1 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
