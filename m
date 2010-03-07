Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0CGRvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 12:51:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59049 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752619Ab0CGRvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 12:51:45 -0500
Date: Sun, 7 Mar 2010 17:51:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Julia Lawall <julia@diku.dk>,
       Dmitry Torokhov <dtor@mail.ru>, Wolfram Sang <w.sang@pengutronix.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] regulator: handle kcalloc() failure
Message-ID: <20100307175144.GB27785@opensource.wolfsonmicro.com>
References: <20100307123645.GB6469@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100307123645.GB6469@bicker>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 03:36:45PM +0300, Dan Carpenter wrote:
> Return -ENOMEM if kcalloc() fails
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
