Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYKXTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYKXTY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYKXTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:24:49 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56892 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYKXTYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:24:48 -0500
Date: Mon, 24 Nov 2008 20:27:27 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add battery health reporting for WM8350
Message-ID: <20081124192726.GB2604@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081120152044.GA15434@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120152044.GA15434@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Nov 20, 2008 at 03:20:44PM +0000, Mark Brown wrote:
> This (brief) series adds a new power supply health state for reporting
> excessively cold batteries then uses it when implementing battery health
> reporting for the WM8350.  I'm not 100% happy with the name for the new
> state but I couldn't think of something consistent with the existing
> OVERHEAT.
> 
> Since the WM8350 PMU driver is queued in the mfd tree it probably makes
> sense to merge this via the same path?
Fine with me. I'll wait for Anton's feedback on those patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
