Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbYJTDMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbYJTDMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYJTDMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:12:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:28469 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYJTDMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HTaJvT5I76zyrJo+TJK69sF9yezWJHVuqSnUC2/+knN9QjFOs80nbR4dOGyqmK2cDW
         Hhen2xv60SWTTlh7NEJqTeM6C9DQEZZmEIxjaecgu4eAqavQR/DO2bYaDNMpkKKPG3sF
         ZF/yDiNYbArnsYzumueO0kyTytgx26/fqwfKg=
Message-ID: <f17812d70810192012k5e553147qd30f5f10aabeaa79@mail.gmail.com>
Date: Mon, 20 Oct 2008 11:12:43 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH] arm: balance parenthesis in header file
Cc: "Eric Miao" <eric.miao@marvell.com>,
       "Russell King" <rmk+kernel@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200810181456.44273.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810181456.44273.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, thanks for the patch. Queued.

On Sat, Oct 18, 2008 at 8:56 PM, Mariusz Kozlowski
<m.kozlowski@tuxland.pl> wrote:
> Hello,
>
>        Introduced by:
>
> commit fff147208b48680cb7b627a144113a6585828a0e
> Author: Eric Miao <eric.miao@marvell.com>
> Date:   Fri Sep 5 22:15:23 2008 +0800
>
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
>
> --- a/arch/arm/mach-pxa/include/mach/spitz.h
> +++ b/arch/arm/mach-pxa/include/mach/spitz.h
> @@ -142,7 +142,7 @@
>
>  #define SPITZ_SCP2_GPIO_BASE           (NR_BUILTIN_GPIO + 12)
>  #define SPITZ_GPIO_IR_ON               (SPITZ_SCP2_GPIO_BASE + 0)
> -#define SPITZ_GPIO_AKIN_PULLUP         (SPITZ_SCP2_GPIO_BASE + 1
> +#define SPITZ_GPIO_AKIN_PULLUP         (SPITZ_SCP2_GPIO_BASE + 1)
>  #define SPITZ_GPIO_RESERVED_1          (SPITZ_SCP2_GPIO_BASE + 2)
>  #define SPITZ_GPIO_RESERVED_2          (SPITZ_SCP2_GPIO_BASE + 3)
>  #define SPITZ_GPIO_RESERVED_3          (SPITZ_SCP2_GPIO_BASE + 4)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
