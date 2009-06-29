Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZF2SF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZF2SF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZF2SFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:05:16 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:33284 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbZF2SFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:05:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAO+eSEpR9cBV/2dsb2JhbADOVgmEBAU
Date: Mon, 29 Jun 2009 20:05:16 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 52/62] drivers/watchdog/bcm47xx_wdt.c: Remove
	unnecessary semicolons
Message-ID: <20090629180516.GH3982@infomag.iguana.be>
References: <cover.1246173664.git.joe@perches.com> <24eea6cba10492e0a19cbb341335e0e024b2a949.1246173683.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24eea6cba10492e0a19cbb341335e0e024b2a949.1246173683.git.joe@perches.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Will add this to the linux-2.6-watchdog trees.

Thanks,
Wim.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/watchdog/bcm47xx_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
> index 5c7011c..751c003 100644
> --- a/drivers/watchdog/bcm47xx_wdt.c
> +++ b/drivers/watchdog/bcm47xx_wdt.c
> @@ -161,7 +161,7 @@ static long bcm47xx_wdt_ioctl(struct file *file,
>  {
>  	void __user *argp = (void __user *)arg;
>  	int __user *p = argp;
> -	int new_value, retval = -EINVAL;;
> +	int new_value, retval = -EINVAL;
>  
>  	switch (cmd) {
>  	case WDIOC_GETSUPPORT:
> -- 
> 1.6.3.1.10.g659a0.dirty
> 
