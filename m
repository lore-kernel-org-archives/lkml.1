Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZF2Kcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZF2Kcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZF2Kcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:32:46 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:59608 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZF2Kcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:32:45 -0400
Subject: Re: [PATCH 37/62] drivers/regulator/pcf50633-regulator.c: Remove
 unnecessary semicolons
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <f56b87d6e81de7d97625fb6c340900ee4f30a30e.1246173682.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	 <f56b87d6e81de7d97625fb6c340900ee4f30a30e.1246173682.git.joe@perches.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 11:32:47 +0100
Message-Id: <1246271567.30631.41.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 09:26 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/regulator/pcf50633-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
> index 8e14900..70ba775 100644
> --- a/drivers/regulator/pcf50633-regulator.c
> +++ b/drivers/regulator/pcf50633-regulator.c
> @@ -155,7 +155,7 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
>  	int regulator_id, millivolts, volt_bits;
>  	u8 regnr;
>  
> -	pcf = rdev_get_drvdata(rdev);;
> +	pcf = rdev_get_drvdata(rdev);
>  
>  	regulator_id = rdev_get_id(rdev);
>  	if (regulator_id >= PCF50633_NUM_REGULATORS)

Applied.

Thanks

Liam

