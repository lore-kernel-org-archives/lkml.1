Return-Path: <linux-kernel-owner+w=401wt.eu-S935316AbXGYSoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316AbXGYSoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933162AbXGYSo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:44:28 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:57880 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934512AbXGYSo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:44:26 -0400
Message-ID: <46A799F9.5050806@namesys.com>
Date: Wed, 25 Jul 2007 22:44:09 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1: reiser4 <-> lzo compile error
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070725182221.GG3572@stusta.de>
In-Reply-To: <20070725182221.GG3572@stusta.de>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

><--  snip  -->
>
>...
>  LD      .tmp_vmlinux1
>lib/built-in.o: In function `lzo1x_1_compress':
>(.text+0x13eae): multiple definition of `lzo1x_1_compress'
>fs/built-in.o:(.text+0x117075): first defined here
>make[1]: *** [.tmp_vmlinux1] Error 1
>
><--  snip  -->
>
>AFAIR, we once had a patch in -mm changing reiser4 to use the
>LZO code that is now in the kernel?
>  
>

Yup, I'll take a look..

>cu
>Adrian
>
>  
>

