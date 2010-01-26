Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550Ab0AZJfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab0AZJfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971Ab0AZJfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:35:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55759 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751559Ab0AZJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:35:08 -0500
References: <20100126041437.GA25411@ldl.fc.hp.com> (sfid-20100126_041446_502146_7E27D0AC)
Message-Id: <BC4F41F7-C56A-490E-A11E-E383F8AA393D@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Chiang <achiang@hp.com>
In-Reply-To: <20100126041437.GA25411@ldl.fc.hp.com> (sfid-20100126_041446_502146_7E27D0AC)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] regulator: trivial: fix typos in user-visible Kconfig text
Date: Tue, 26 Jan 2010 09:35:27 +0000
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 Jan 2010, at 04:14, Alex Chiang <achiang@hp.com> wrote:

> Fix Kconfig text for some Wolfson Micro devices.
>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> ---
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 262f62e..c565e0d 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -91,14 +91,14 @@ config REGULATOR_WM831X
>      of PMIC devices.
>
> config REGULATOR_WM8350
> -    tristate "Wolfson Microelectroncis WM8350 AudioPlus PMIC"
> +    tristate "Wolfson Microelectronics WM8350 AudioPlus PMIC"
>    depends on MFD_WM8350
>    help
>      This driver provides support for the voltage and current  
> regulators
>           of the WM8350 AudioPlus PMIC.
>
> config REGULATOR_WM8400
> -    tristate "Wolfson Microelectroncis WM8400 AudioPlus PMIC"
> +    tristate "Wolfson Microelectronics WM8400 AudioPlus PMIC"
>    depends on MFD_WM8400
>    help
>      This driver provides support for the voltage regulators of the
