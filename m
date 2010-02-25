Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab0BYLCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:02:46 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47367 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0BYLCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:02:44 -0500
Subject: Re: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver
 data handling
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100225095536.GC10823@core.coreip.homeip.net>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
	 <20100224073849.15964.62321.stgit@localhost.localdomain>
	 <20100224102548.GG18896@rakim.wolfsonmicro.main>
	 <20100224190234.GD25304@core.coreip.homeip.net>
	 <20100224191402.GA8316@rakim.wolfsonmicro.main>
	 <20100224192126.GE25304@core.coreip.homeip.net>
	 <20100224204056.GA6824@rakim.wolfsonmicro.main>
	 <20100225095536.GC10823@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 11:02:39 +0000
Message-ID: <1267095759.4037.158.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 01:55 -0800, Dmitry Torokhov wrote:
> regulator: wm8400 - cleanup platform driver data handling
> 
> Driver data set by platform_set_drvdata() is for private use of
> the driver currently bound to teh device and not for use by parent,
> subsystem and anyone else.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/regulator/wm8400-regulator.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

