Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbXEIVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbXEIVxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbXEIVxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:53:00 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:47509 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012AbXEIVw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:52:58 -0400
Message-ID: <464242B6.9020508@simon.arlott.org.uk>
Date: Wed, 09 May 2007 22:52:54 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: rpjday@mindspring.com
Subject: Re: Fix misspellings collected by members of KJ list.
References: <200705092102.l49L29Bt026911@hera.kernel.org>
In-Reply-To: <200705092102.l49L29Bt026911@hera.kernel.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/07 22:02, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=beb7dd86a101263bf63a78c7c6d4da3849b35bd6
> Commit:     beb7dd86a101263bf63a78c7c6d4da3849b35bd6
> Parent:     3dde6ad8fc3939d345a3768464ecff43c91d511a
> Author:     Robert P. J. Day <rpjday@mindspring.com>
> AuthorDate: Wed May 9 07:14:03 2007 +0200
> Committer:  Adrian Bunk <bunk@stusta.de>
> CommitDate: Wed May 9 07:14:03 2007 +0200
> 
>     Fix misspellings collected by members of KJ list.
>     
>     Fix the misspellings of "propogate", "writting" and (oh, the shame
>     :-) "kenrel" in the source tree.
>     
>     Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>     Signed-off-by: Adrian Bunk <bunk@stusta.de>
> ---
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index 7710a6a..f6ac1d3 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -1607,11 +1607,11 @@ void stop_tty(struct tty_struct *tty)
>  EXPORT_SYMBOL(stop_tty);
>  
>  /**
> - *	start_tty	-	propogate flow control
> + *	start_tty	-	propagate flow control
>   *	@tty: tty to start
>   *
>   *	Start a tty that has been stopped if at all possible. Perform
> - *	any neccessary wakeups and propogate the TIOCPKT status. If this
> + *	any neccessary wakeups and propagate the TIOCPKT status. If this
>   *	is the tty was previous stopped and is being started then the
>   *	driver start method is invoked and the line discipline woken.
>   *

There's only one c in necessary.

-- 
Simon Arlott
