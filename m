Return-Path: <linux-kernel-owner+w=401wt.eu-S1750964AbXDHMHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbXDHMHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 08:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXDHMHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 08:07:51 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3189 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXDHMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 08:07:50 -0400
Date: Sun, 8 Apr 2007 13:07:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
       Marek =?utf-8?B?VmHFoXV0?= <marek.vasut@gmail.com>
Subject: Re: [PATCH 29/90] ARM: OMAP: Palm Tungsten|T support
Message-ID: <20070408120740.GC5431@flint.arm.linux.org.uk>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
	Marek =?utf-8?B?VmHFoXV0?= <marek.vasut@gmail.com>
References: <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <20070406120923.GB3866@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070406120923.GB3866@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 12:09:23PM +0000, Pavel Machek wrote:
> On Wed 2007-04-04 14:05:08, Tony Lindgren wrote:
> 
> > From: =?utf-8?q?Marek_Va=C5=A1ut?= <marek.vasut@gmail.com>
> 
> EEk.
> 
> > Signed-off-by: Marek Vašut <marek.vasut@gmail.com>
> 
> Eek2.

As I see it, that eek2 is correct UTF-8, and since the body charset was
utf-8 I don't see this as a problem.

As far as the first goes, doesn't git parse qp-encoded From lines?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
