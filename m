Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbXH0Vav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbXH0Vav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765216AbXH0V1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58803 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765204AbXH0V1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:48 -0400
Date: Mon, 27 Aug 2007 23:27:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-kernel@vger.kernel.org, linux-m32r@ml.linux-m32r.org
Subject: 2.6.23-rc3-mm1: m32r defconfig compile error
Message-ID: <20070827212748.GO4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
>  git-m32r.patch
>...
>  git trees
>...

<--  snip  -->

...
  AS      arch/m32r/kernel/entry.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc3-mm1/arch/m32r/kernel/entry.S: Assembler messages:
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc3-mm1/arch/m32r/kernel/entry.S:358: Error: bad instruction `addi r0,#(((((0)+(64))+(32))+(32)))'
make[2]: *** [arch/m32r/kernel/entry.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

