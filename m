Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab0BYKna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:43:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60037 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759215Ab0BYKn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:43:28 -0500
Date: Thu, 25 Feb 2010 10:43:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver
 data handling
Message-ID: <20100225104326.GA11071@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073849.15964.62321.stgit@localhost.localdomain>
 <20100224102548.GG18896@rakim.wolfsonmicro.main>
 <20100224190234.GD25304@core.coreip.homeip.net>
 <20100224191402.GA8316@rakim.wolfsonmicro.main>
 <20100224192126.GE25304@core.coreip.homeip.net>
 <20100224204056.GA6824@rakim.wolfsonmicro.main>
 <20100225095536.GC10823@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225095536.GC10823@core.coreip.homeip.net>
X-Cookie: f u cn rd ths, u r prbbly a lsy spllr.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 01:55:37AM -0800, Dmitry Torokhov wrote:

> Fair enough, I removed the offending part, updated patch below.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> -- 
> Dmitry
> 
> regulator: wm8400 - cleanup platform driver data handling

but note that including the patch after your sig separator means that a
lot of MUAs will hide the patch from users which makes it a bit hard to
read.
