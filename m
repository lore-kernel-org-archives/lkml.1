Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYKXTXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYKXTXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYKXTWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:22:55 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56713 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYKXTWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:22:54 -0500
Date: Mon, 24 Nov 2008 20:25:32 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Switch WM8350 revision detection to a feature
	based model
Message-ID: <20081124192531.GA2604@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1227113220-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081124103755.GA3479@sortiz.org> <20081124133116.GA31269@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124133116.GA31269@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 01:31:16PM +0000, Mark Brown wrote:
> On Mon, Nov 24, 2008 at 11:37:55AM +0100, Samuel Ortiz wrote:
> 
> > Dont you prefer to use the WM8350_REV_* values in your code rather than some
> > undocumented constants like that ?
> > I understand that reading the code below will make those constants obvious,
> > but still...
> 
> I don't find them enormously helpful, TBH - the constant gets used in
> exactly one place and there's been a bit of skew between what some of
> the ID registers are called and thier actual meaning which doesn't help.
> 
> I'll repost with the #defines for the revisons added back, though.
Thanks for the patches. Both of them are now sitting in my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
