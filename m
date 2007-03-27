Return-Path: <linux-kernel-owner+w=401wt.eu-S965469AbXC0V0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469AbXC0V0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965445AbXC0V0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:26:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36336 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965469AbXC0V0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:26:03 -0400
Date: Tue, 27 Mar 2007 23:26:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: 2.6.21-rc5-mm1: i386/x86_64 register_die_notifier() change
Message-ID: <20070327212605.GE16477@stusta.de>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070326205706.a750bb35.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 08:57:06PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc4-mm1:
>...
> +move-die-notifier-handling-to-common-code.patch
>...
>  Misc
>...

Is the removal of the vmalloc_sync_all() call in register_die_notifier() 
on i386 and x86_64 both intentional and correct?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

