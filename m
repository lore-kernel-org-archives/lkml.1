Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109Ab0AQVyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0AQVyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220Ab0AQVyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:54:03 -0500
Received: from xenotime.net ([72.52.64.118]:41874 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755050Ab0AQVyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:54:00 -0500
Date: Sun, 17 Jan 2010 13:53:58 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: trivial@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo s/programme/program/ in mtrr
 documentation
Message-Id: <20100117135358.7db2e7f5.rdunlap@xenotime.net>
In-Reply-To: <1263763552-9656-1-git-send-email-cascardo@holoscopio.com>
References: <1263763552-9656-1-git-send-email-cascardo@holoscopio.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 19:25:51 -0200 Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/x86/mtrr.txt |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/x86/mtrr.txt b/Documentation/x86/mtrr.txt
> index cc071dc..3ffcbea 100644
> --- a/Documentation/x86/mtrr.txt
> +++ b/Documentation/x86/mtrr.txt
> @@ -195,11 +195,11 @@ int main ()
>      exit (3);
>  }   /*  End Function main  */
>  ===============================================================================
> -Creating MTRRs from a C programme using ioctl()'s:
> +Creating MTRRs from a C program using ioctl()'s:
>  
>  /*  mtrr-add.c
>  
> -    Source file for mtrr-add (example programme to add an MTRRs using ioctl())
> +    Source file for mtrr-add (example program to add MTRRs using ioctl())
>  
>      Copyright (C) 1997-1998  Richard Gooch
>  
> @@ -223,7 +223,7 @@ Creating MTRRs from a C programme using ioctl()'s:
>  */
>  
>  /*
> -    This programme will use an ioctl() on /proc/mtrr to add an entry. The first
> +    This program will use an ioctl() on /proc/mtrr to add an entry. The first
>      available mtrr is used. This is an alternative to writing /proc/mtrr.
>  
>  
> -- 

We accept UK/British English spellings as is.

---
~Randy
