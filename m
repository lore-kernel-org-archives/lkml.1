Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZIFF5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZIFF5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZIFF5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:57:35 -0400
Received: from compulab.co.il ([67.18.134.219]:34253 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZIFF5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:57:35 -0400
Message-ID: <4AA34F4F.8080402@compulab.co.il>
Date: Sun, 06 Sep 2009 08:57:35 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.21 (X11/20090712)
MIME-Version: 1.0
To: Michael Prokop <mika@grml.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/regulator/Kconfig: fix typo (s/Usersapce/Userspace/)
 in REGULATOR_USERSPACE_CONSUMER description
References: <1252112354-20006-1-git-send-email-mika@grml.org>
In-Reply-To: <1252112354-20006-1-git-send-email-mika@grml.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Michael Prokop wrote:
> Signed-off-by: Michael Prokop <mika@grml.org>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> ---
>  drivers/regulator/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index f431779..4d9fa22 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -52,7 +52,7 @@ config REGULATOR_USERSPACE_CONSUMER
>  	default n
>  	help
>  	  There are some classes of devices that are controlled entirely
> -	  from user space. Usersapce consumer driver provides ability to
> +	  from user space. Userspace consumer driver provides ability to
>  	  control power supplies for such devices.
>  
>            If unsure, say no.

-- 
Sincerely yours,
Mike.

