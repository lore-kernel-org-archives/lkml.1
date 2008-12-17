Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754323AbYLQORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYLQORP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 09:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYLQOQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 09:16:57 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:50205 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYLQOQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 09:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ianmn4t8ye30aphcJulpBSJFh0rEzW5R2IxPi9HpQttYt95fYaQZnxHmVIxkDLaK+9
         3j3yp2prpTBzJwhC19IDwmRs9F6WhvXWL0CEAizrO591hv7yrPnYF2ZQwpCzJwwTRvau
         vYfgy0sJbKkvtPiCtafzAt6jgMI+Hyb+mJ+Hg=
Message-ID: <3f9a31f40812170616h3c4eb54fo20e325e7d763b490@mail.gmail.com>
Date: Wed, 17 Dec 2008 19:46:56 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] avr32: Introducing asm/syscalls.h
Cc: "Jaswinder Singh" <jaswinder@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081217135507.69b9bbd5@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216973918.26114.1.camel@jaswinder.satnam>
	 <20081217135507.69b9bbd5@hskinnemoen-d830>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

On Wed, Dec 17, 2008 at 6:25 PM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> Jaswinder Singh wrote:
>> Declaring arch-dependent syscalls for avr32 architecture
>>
>> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
>
> Applied, thanks. Sorry it took so long...I was kind of wondering what
> happened to the rest of the series and then I forgot about the whole
> thing.

Basically I prepared syscalls.h for x86 :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/x86/include/asm/syscalls.h;h=87803da440100d50222d86cf7a1ac9cf00ed29ca;hb=HEAD

On David's request I also prepared for other arch.

But it totally depends on arch maintainers to include or not.

Thank you,

Jaswinder Singh.
