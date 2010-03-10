Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0CJIEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:04:34 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39769 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0CJIEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:04:31 -0500
Subject: Re: [patch] regulator: handle kcalloc() failure
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Julia Lawall <julia@diku.dk>, Dmitry Torokhov <dtor@mail.ru>,
       Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <20100307123645.GB6469@bicker>
References: <20100307123645.GB6469@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 08:04:25 +0000
Message-ID: <1268208265.3760.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-07 at 15:36 +0300, Dan Carpenter wrote:
> Return -ENOMEM if kcalloc() fails
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

