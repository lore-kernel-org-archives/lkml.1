Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbYD2ONC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbYD2ONC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYD2OMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:12:53 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37548 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYD2OMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:12:53 -0400
Date: Tue, 29 Apr 2008 17:12:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Sort ordering
Message-ID: <20080429141215.GB30524@cs181133002.pp.htv.fi>
References: <20080429143950.4f75b517@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080429143950.4f75b517@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 02:39:50PM +0100, Alan Cox wrote:
>...
> --- linux.vanilla-2.6.25-mm1/MAINTAINERS	2008-04-28 11:36:47.000000000 +0100
> +++ linux-2.6.25-mm1/MAINTAINERS	2008-04-28 14:14:24.000000000 +0100
>...
>  USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
>  P:	Gary Brubaker
>  M:	xavyer@ix.netcom.com
> @@ -4237,7 +4236,7 @@
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  
> -FAT/VFAT/MSDOS FILESYSTEM:
> +VFAT/FAT/MSDOS FILESYSTEM:
>  P:	OGAWA Hirofumi
>  M:	hirofumi@mail.parknet.co.jp
>  L:	linux-kernel@vger.kernel.org
> @@ -4282,6 +4281,13 @@
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  
> +UltraSPARC (sparc64):
> +P:	David S. Miller
> +M:	davem@davemloft.net
> +L:	sparclinux@vger.kernel.org
> +T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
> +S:	Maintained
>...

V is between U and U?

Not your fault, but when you're anyway sorting the entries you could 
also sort the U/V confusion...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

