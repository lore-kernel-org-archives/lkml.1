Return-Path: <linux-kernel-owner+w=401wt.eu-S1031711AbXEKT5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031711AbXEKT5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966685AbXEKT4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:56:21 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:40398 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966862AbXEKT4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:56:19 -0400
Message-ID: <4644CA60.8080809@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:56:16 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org, trivial@kernel.org
Subject: Re: [PATCH] spelling fixes: arch/mips/
References: <4644C721.501@simon.arlott.org.uk>
In-Reply-To: <4644C721.501@simon.arlott.org.uk>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/07 20:42, Simon Arlott wrote:
> diff --git a/arch/mips/kernel/semaphore.c b/arch/mips/kernel/semaphore.c
> index 1265358..b363604 100644
> --- a/arch/mips/kernel/semaphore.c
> +++ b/arch/mips/kernel/semaphore.c
> @@ -33,7 +33,7 @@
>  *    return old_count;
>  *
>  * On machines without lld/scd we need a spinlock to make the 
> manipulation of
> - * sem->count and sem->waking atomic.  Scalability isn't an issue because
> + * sem->count and sem->waking atomic.  Scalibility isn't an issue because
>  * this lock is used on UP only so it's just an empty variable.
>  */
> static inline int __sem_update_count(struct semaphore *sem, int incr)

I thought I'd reverted that mistake... it was correct already, too many 
"capability" fixes confusing me :/

-- 
Simon Arlott
