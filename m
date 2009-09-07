Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZIGKJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZIGKJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZIGKJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:09:07 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49029 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZIGKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:09:06 -0400
Subject: Re: [PATCH] drivers/regulator/Kconfig: fix typo
 (s/Usersapce/Userspace/) in REGULATOR_USERSPACE_CONSUMER description
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Michael Prokop <mika@grml.org>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <1252112354-20006-1-git-send-email-mika@grml.org>
References: <1252112354-20006-1-git-send-email-mika@grml.org>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 11:09:06 +0100
Message-Id: <1252318146.5876.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 02:59 +0200, Michael Prokop wrote:
> Signed-off-by: Michael Prokop <mika@grml.org>
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

Applied.

Thanks

Liam

