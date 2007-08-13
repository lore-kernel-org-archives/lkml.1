Return-Path: <linux-kernel-owner+w=401wt.eu-S973290AbXHMNqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973290AbXHMNqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933986AbXHMKOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:14:32 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4644 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933967AbXHMKOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:14:30 -0400
Date: Mon, 13 Aug 2007 12:14:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: joe@perches.com
Cc: r.marek@assembler.cz, linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       akpm@linux-foundation.org
Subject: Re: [i2c] [PATCH] [37/2many] MAINTAINERS - ALI1563 I2C DRIVER
Message-ID: <20070813121455.5494f08a@hyperion.delvare>
In-Reply-To: <46bff8a9.FJdmih5x59gs5DLA%joe@perches.com>
References: <46bff8a9.FJdmih5x59gs5DLA%joe@perches.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:22:33 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3a586da..eeb1bf9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -367,6 +367,7 @@ P:	Rudolf Marek
>  M:	r.marek@assembler.cz
>  L:	i2c@lm-sensors.org
>  S:	Maintained

+F: Documentation/i2c/busses/i2c-ali1563

> +F:	drivers/i2c/busses/i2c-ali1563.c
>  
>  ALPHA PORT
>  P:	Richard Henderson


-- 
Jean Delvare
