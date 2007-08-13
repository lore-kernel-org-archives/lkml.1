Return-Path: <linux-kernel-owner+w=401wt.eu-S945442AbXHMNcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945442AbXHMNcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943425AbXHMJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:35:12 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:62239 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937758AbXHMJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:35:07 -0400
Date: Mon, 13 Aug 2007 11:35:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [29/2many] MAINTAINERS - ADM1025 HARDWARE MONITOR
 DRIVER
Message-ID: <20070813113531.0632f551@hyperion.delvare>
In-Reply-To: <46bff89a.xYL7oyBOdTr8eyH/%joe@perches.com>
References: <46bff89a.xYL7oyBOdTr8eyH/%joe@perches.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

What a storm :( This should have been one single patch IMHO, or grouped
by maintainer or subsystem or something.

On Sun, 12 Aug 2007 23:22:18 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry

Can you please point me to where this new pattern was discussed?

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4faf1ce..91bc5cd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -307,6 +307,7 @@ P:	Jean Delvare
>  M:	khali@linux-fr.org
>  L:	lm-sensors@lm-sensors.org
>  S:	Maintained

+F: Documentation/hwmon/adm1025

> +F:	drivers/hwmon/adm1025.c
>  
>  ADM1029 HARDWARE MONITOR DRIVER
>  P:	Corentin Labbe

Other patches I don't comment on, means I'm fine with them.

-- 
Jean Delvare
