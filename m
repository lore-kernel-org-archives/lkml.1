Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYDGLMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYDGLMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYDGLM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:12:27 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39413 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYDGLM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:12:27 -0400
Date: Mon, 7 Apr 2008 14:11:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Lazy <lazy404@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24.4 compilation error
Message-ID: <20080407111150.GD20257@cs181133002.pp.htv.fi>
References: <efeafa350804070321ka6cbb46pd49a62fc325eb4e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <efeafa350804070321ka6cbb46pd49a62fc325eb4e0@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 12:21:20PM +0200, Lazy wrote:
> make bzImage
> ...
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `getnstimeofday':
> (.text+0x22bdc): undefined reference to `__umoddi3'
>...
> Gnu C                  4.3.0
>...

Known issue, use an older gcc or wait for 2.6.24.5 .

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

