Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0BGTNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:13:32 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39677 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0BGTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:13:30 -0500
Message-ID: <4B6F104C.10705@monstr.eu>
Date: Sun, 07 Feb 2010 20:11:08 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 05/16] microblaze: remove trailing space in messages
References: <201002061844.45212.elendil@planet.nl> <1265478443-31072-5-git-send-email-elendil@planet.nl>
In-Reply-To: <1265478443-31072-5-git-send-email-elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Michal Simek <monstr@monstr.eu>

Frans Pop wrote:
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: microblaze-uclinux@itee.uq.edu.au
> Cc: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/kernel/cpu/cache.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/cpu/cache.c b/arch/microblaze/kernel/cpu/cache.c
> index d9d6383..a2c8009 100644
> --- a/arch/microblaze/kernel/cpu/cache.c
> +++ b/arch/microblaze/kernel/cpu/cache.c
> @@ -504,7 +504,7 @@ const struct scache wt_nomsr_noirq = {
>  #define CPUVER_7_20_A	0x0c
>  #define CPUVER_7_20_D	0x0f
>  
> -#define INFO(s)	printk(KERN_INFO "cache: " s " \n");
> +#define INFO(s)	printk(KERN_INFO "cache: " s "\n");
>  
>  void microblaze_cache_init(void)
>  {


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
