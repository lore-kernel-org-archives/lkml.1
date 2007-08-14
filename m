Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbXHNNIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbXHNNIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbXHNNIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:08:06 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:35257 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbXHNNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:08:04 -0400
Date: Tue, 14 Aug 2007 22:07:19 +0900
From: Mattia Dongili <malattia@linux.it>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [446/2many] MAINTAINERS - SONY VAIO CONTROL DEVICE
	DRIVER
Message-ID: <20070814130718.GA1612@inferi.kami.home>
References: <46bffbdb.CiCc1bB4g9HMdx0f%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffbdb.CiCc1bB4g9HMdx0f%joe@perches.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.23-rc1-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:36:11PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mattia Dongili <malattia@linux.it>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6175c77..ea4d9d9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4241,6 +4241,8 @@ M:	malattia@linux.it
>  L:	linux-acpi@vger.kernel.org
>  W:	http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
>  S:	Maintained
> +F:	drivers/char/sonypi.c
> +F:	drivers/misc/sony-laptop.c
>  
>  SOUND
>  P:	Jaroslav Kysela
> 
-- 
mattia
:wq!
