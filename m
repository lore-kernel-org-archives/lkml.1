Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZGBO4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZGBO4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZGBO4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:56:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:44251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbZGBOz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:55:59 -0400
MIME-Version: 1.0
In-Reply-To: <1246515155-23823-1-git-send-email-monstr@monstr.eu>
References: <1246515155-23823-1-git-send-email-monstr@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 2 Jul 2009 08:55:41 -0600
Message-ID: <fa686aa40907020755l16d38a44t1a759d9731fb1022@mail.gmail.com>
Subject: Re: [PATCH] leds: gpio-leds: Fix typographics fault
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, raph@8d.com, dbrownell@users.sourceforge.net,
       diego.dompe@ridgerun.com, rpurdie@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 12:12 AM, <monstr@monstr.eu> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/leds/leds-gpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 6b06638..107e5ae 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -80,7 +80,7 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
>
>        /* skip leds that aren't available */
>        if (!gpio_is_valid(template->gpio)) {
> -               printk(KERN_INFO "Skipping unavilable LED gpio %d (%s)\n",
> +               printk(KERN_INFO "Skipping unavailable LED gpio %d (%s)\n",
>                                template->gpio, template->name);
>                return 0;
>        }
> --
> 1.5.5.1
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
