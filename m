Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYATT42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYATT42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYATT4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:56:20 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23222 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbYATT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:56:19 -0500
Date: Sun, 20 Jan 2008 11:54:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] SG - fix SH Kconfig
Message-Id: <20080120115406.c092be4e.randy.dunlap@oracle.com>
In-Reply-To: <1200853109.6331.2.camel@localhost.localdomain>
References: <1200853109.6331.2.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jan 2008 18:18:29 +0000 Adrian McMenamin wrote:

> From: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
> 
> Remove reference to board deleted in commit 758e06ded4c48024835ef0a14627afcde2e25929
> 
> Submitted-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

s/Submitted/Signed-off/

What is "SG" in $subject for?


> ---
> 
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 85bd9ac..e94430b 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -518,7 +518,6 @@ config SH_CAYMAN
>  
>  endmenu
>  
> -source "arch/sh/boards/renesas/hs7751rvoip/Kconfig"
>  source "arch/sh/boards/renesas/rts7751r2d/Kconfig"
>  source "arch/sh/boards/renesas/r7780rp/Kconfig"
>  source "arch/sh/boards/magicpanelr2/Kconfig"

---
~Randy
