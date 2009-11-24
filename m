Return-Path: <linux-kernel-owner+w=401wt.eu-S934448AbZKXXdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448AbZKXXdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934344AbZKXXdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:33:49 -0500
Received: from mga05.intel.com ([192.55.52.89]:51199 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934319AbZKXXds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:33:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,281,1257148800"; 
   d="scan'208";a="750110407"
Date: Wed, 25 Nov 2009 00:35:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091124233518.GJ8290@sortiz.org>
References: <20091123143503.3cdf8dee.sfr@canb.auug.org.au>
 <20091123122606.GA3616@sortiz.org>
 <20091123163211.GB3491@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123163211.GB3491@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On Mon, Nov 23, 2009 at 08:32:11AM -0800, Dmitry Torokhov wrote:
> > Could we split the above fix so that we get back to the:
> > 
> > 	struct platform_device *rtc_pdev;
> > 	struct platform_device *mbc_pdev;
> > 	struct platform_device *adc_pdev;
> > 	struct platform_device *input_pdev;
> > 	struct platform_device *regulator_pdev[PCF50633_NUM_REGULATORS];
> > 
> > structure ? We can move to the index based structure after the next merge
> > window. That would make my life easier in terms of tree dependencies.
> > If you dont have time to do this change, I'll do it some time this week.
> > 
> 
> Please feel free to drop or reschedule the patch as you see fit. I don't
> have any problem if it will go in later.
Yes, I'll requeue your patchset after the next merge window is closed.
Thanks for your understanding.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
