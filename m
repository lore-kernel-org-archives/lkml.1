Return-Path: <linux-kernel-owner+w=401wt.eu-S1031581AbXEKT4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031581AbXEKT4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763756AbXEKTzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:55:18 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:40396 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763539AbXEKTzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:55:15 -0400
Message-ID: <4644CA20.2060606@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:55:12 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] spelling fixes: arch/ia64/
References: <4644C6FD.6010004@simon.arlott.org.uk>
In-Reply-To: <4644C6FD.6010004@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/07 20:41, Simon Arlott wrote:
> diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
> index a06667c..bf7e7b5 100644
> --- a/arch/ia64/kernel/time.c
> +++ b/arch/ia64/kernel/time.c
> @@ -216,7 +216,7 @@ ia64_init_itm (void)
> #ifdef CONFIG_SMP
>         /* On IA64 in an SMP configuration ITCs are never accurately 
> synchronized.
>          * Jitter compensation requires a cmpxchg which may limit
> -         * the scalability of the syscalls for retrieving time.
> +         * the scalibility of the syscalls for retrieving time.
>          * The ITC synchronization is usually successful to within a few
>          * ITC ticks but this is not a sure thing. If you need to improve
>          * timer performance in SMP situations then boot the kernel with 
> the

I thought I'd reverted that mistake... it was correct already :/

-- 
Simon Arlott
