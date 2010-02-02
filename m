Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0BBHQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:16:46 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:54662 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab0BBHQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:16:44 -0500
Message-ID: <4B67D14C.1020807@billgatliff.com>
Date: Tue, 02 Feb 2010 01:16:28 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-embedded@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 3/5] Expunge old Atmel PWMC driver, replacing it with
 one that conforms to the PWM API
References: <cover.1265094517.git.bgat@billgatliff.com> <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com> <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com> <f5be82a3ae501709e8568e9fa06ab036fd363567.1265094517.git.bgat@billgatliff.com>
In-Reply-To: <f5be82a3ae501709e8568e9fa06ab036fd363567.1265094517.git.bgat@billgatliff.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Gatliff wrote:
>
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 049ff24..8cf48cf 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -5,7 +5,11 @@
>  obj-$(CONFIG_IBM_ASM)		+= ibmasm/
>  obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
>  obj-$(CONFIG_AD525X_DPOT)	+= ad525x_dpot.o
> -obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
> +obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
> +obj-$(CONFIG_EEEPC_LAPTOP)	+= eeepc-laptop.o
> +obj-$(CONFIG_MSI_LAPTOP)	+= msi-laptop.o
> +obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
> +obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
>   

Darn it!!  I'll clean this one up in the final post.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com


