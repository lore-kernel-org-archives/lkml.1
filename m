Return-Path: <linux-kernel-owner+w=401wt.eu-S1750872AbXCEAL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872AbXCEAL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbXCEAL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:11:59 -0500
Received: from smtp.ono.com ([62.42.230.12]:42429 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750699AbXCEAL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:11:58 -0500
Date: Mon, 5 Mar 2007 01:11:33 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-ID: <20070305011133.570a9ba8@werewolf-wl>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.0cvs15 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> 

nfs blocks shutdown and reboot.
If I try to do 'service nfs stop', the box hangs, no login, no SysRQ-T or P,
S-U-B works at least.

Any ideas ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam01 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #1 SMP PREEMPT
