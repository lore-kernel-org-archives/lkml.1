Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZESJ6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZESJ6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbZESJ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:58:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56088 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZESJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:58:47 -0400
Date: Tue, 19 May 2009 10:58:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, kyungmin.park@samsung.com
Subject: Re: [PATCH] LP3971 PMIC regulator driver (updated and combined
	version)
Message-ID: <20090519095847.GE27195@sirena.org.uk>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local> <20090515092030.GA2202@rakim.wolfsonmicro.main> <1242641718.5473.2156.camel@vega.slimlogic.co.uk> <000601c9d7ac$58af73d0$0a0e5b70$%szyprowski@samsung.com> <1242647032.5473.2162.camel@vega.slimlogic.co.uk> <002c01c9d843$69b09b40$3d11d1c0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002c01c9d843$69b09b40$3d11d1c0$%szyprowski@samsung.com>
X-Cookie: Am I in GRADUATE SCHOOL yet?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 07:33:55AM +0200, Marek Szyprowski wrote:
> This patch adds regulator drivers for National Semiconductors LP3971 PMIC.
> This LP3971 PMIC controller has 3 DC/DC voltage converters and 5 low
> drop-out
> (LDO) regulators. LP3971 PMIC controller uses I2C interface.

> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

> +static int lp3971_dcdc_list_voltage(struct regulator_dev *dev, unsigned
> index)

I'm OK with this but it looks like your MUA has mangled the patch by
word wrapping so Liam may not be able to apply it.  There's some hints
on configuring various mail clients in Documentation/email-clients.txt
which might be helpful.

For unmodified reposts please feel free to add my

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
