Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab0BYKhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:37:22 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56994 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193Ab0BYKhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:37:19 -0500
Subject: Re: [PATCH 06/14] Regulators: tps6507x-regulator - mark probe
 method as __devinit
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100224073811.15964.36760.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
	 <20100224073811.15964.36760.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 10:37:15 +0000
Message-ID: <1267094235.4037.126.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 23:38 -0800, Dmitry Torokhov wrote:
> Also move error handling in probe() out of line and do not bother
> to reset fields in structures that are about to be freed.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

