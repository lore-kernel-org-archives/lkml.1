Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbYEWGks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbYEWGks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYEWGkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:40:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42901 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYEWGkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:40:36 -0400
To: penguin-kernel@i-love.sakura.ne.jp
CC: miklos@szeredi.hu, hch@infradead.org, viro@ZenIV.linux.org.uk,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <200805230400.m4N40f6W010852@www262.sakura.ne.jp> (message from
	Tetsuo Handa on Fri, 23 May 2008 13:00:41 +0900)
Subject: Re: [git patch] vfs: permission API cleanup (v2)
References: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu> <200805230400.m4N40f6W010852@www262.sakura.ne.jp>
Message-Id: <E1JzQwy-0001Dp-E8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 08:40:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Add EXPORT_SYMBOL(check_execute).
> 
> NFS needs check_execute().
> 
>   Kernel: arch/x86/boot/bzImage is ready  (#1)
>     Building modules, stage 2.
>   ERROR: "check_execute" [fs/nfs/nfs.ko] undefined!
>   make[1]: *** [__modpost] Error 1
>   make: *** [modules] Error 2

Thanks.  Both patches applied.

I really appreciate your testing on this tree.

Thanks,
Miklos
