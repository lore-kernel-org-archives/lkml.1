Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZIAIkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZIAIkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZIAIkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:40:01 -0400
Received: from mga05.intel.com ([192.55.52.89]:48093 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753007AbZIAIkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:40:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,311,1249282800"; 
   d="scan'208";a="722797830"
Date: Tue, 1 Sep 2009 10:42:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       rtc-linux@googlegroups.com
Subject: Re: [rtc-linux] [PATCH] AB3100 RTC support v4
Message-ID: <20090901084203.GA4277@sortiz.org>
References: <1251668944-32222-1-git-send-email-linus.walleij@stericsson.com>
 <63386a3d0909010026x72cd4adcyc86927fbf4966c24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0909010026x72cd4adcyc86927fbf4966c24@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Sep 01, 2009 at 09:26:29AM +0200, Linus Walleij wrote:
> 2009/8/30 Linus Walleij <linus.walleij@stericsson.com>:
> 
> > This adds support for the RTC found inside the AB3100 Mixed Signal chip.
> > The symbols used for communicating with the chip is found in the
> > mfd/ab3100-core.c driver that also provides the platform device.
> >
> > Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> > Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> > Changelog v3->v4
> > - Remove error message that will be given by the RTC core anyway.
> > - Suggest to push this through Sam's MFD tree if it's OK with Sam.
> 
> No further comments on this it seems, Sam can you pick it into the
> MFD tree or shall I send it en route to akpm?
It's already queued on my local tree, will push it today.

Cheers,
Samuel.


> Linus

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
