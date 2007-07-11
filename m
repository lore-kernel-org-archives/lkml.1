Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbXGKEtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbXGKEtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXGKEtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:49:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22097 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbXGKEtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:49:07 -0400
Message-ID: <46946201.9030803@oracle.com>
Date: Tue, 10 Jul 2007 21:52:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][DOC]hpet.txt broken link fix
References: <20070711112535.GA13395@darkstar.te-china.tietoenator.com>
In-Reply-To: <20070711112535.GA13395@darkstar.te-china.tietoenator.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> Hi, randy
> 
> how about remove the spec links in the header files as well.
> 
> Subject:
> Remove document links in hpet header files.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Agreed.  Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> include/asm-i386/hpet.h   |    6 ------
> include/asm-x86_64/hpet.h |    6 ------
> 2 files changed, 12 deletions(-)
> 
> diff -pur linux/include/asm-i386/hpet.h linux.new/include/asm-i386/hpet.h
> --- linux/include/asm-i386/hpet.h	2007-07-11 11:15:42.000000000 +0000
> +++ linux.new/include/asm-i386/hpet.h	2007-07-11 11:16:51.000000000 +0000
> @@ -28,12 +28,6 @@
>  
>  #include <linux/timex.h>
>  
> -/*
> - * Documentation on HPET can be found at:
> - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> - */
> -
>  #define HPET_MMAP_SIZE	1024
>  
>  #define HPET_ID		0x000
> diff -pur linux/include/asm-x86_64/hpet.h linux.new/include/asm-x86_64/hpet.h
> --- linux/include/asm-x86_64/hpet.h	2007-07-11 11:16:07.000000000 +0000
> +++ linux.new/include/asm-x86_64/hpet.h	2007-07-11 11:17:03.000000000 +0000
> @@ -1,12 +1,6 @@
>  #ifndef _ASM_X8664_HPET_H
>  #define _ASM_X8664_HPET_H 1
>  
> -/*
> - * Documentation on HPET can be found at:
> - *      http://www.intel.com/ial/home/sp/pcmmspec.htm
> - *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
> - */
> -
>  #define HPET_MMAP_SIZE	1024
>  
>  #define HPET_ID		0x000

