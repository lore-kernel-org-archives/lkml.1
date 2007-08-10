Return-Path: <linux-kernel-owner+w=401wt.eu-S941511AbXHJTiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941511AbXHJTiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbXHJThy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:37:54 -0400
Received: from 1wt.eu ([62.212.114.60]:1273 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714AbXHJThx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:37:53 -0400
Date: Fri, 10 Aug 2007 21:29:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: ES L <esrndmail@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.12 Kernel Panic
Message-ID: <20070810192957.GG6002@1wt.eu>
References: <a06c13a20708100301g437d93cdp47beac4ca1c301a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a06c13a20708100301g437d93cdp47beac4ca1c301a0@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 06:01:33PM +0800, ES L wrote:
> Dear all linux kernel experts,
> 
> Do help me asap as this is an urgent case. I'd compiled 2.6.12 linux
> fedora kernel and I encountered kernel panic when i boot it. My
> machine is Dell Optiplex GX520. This is the error message:
> 
>   umount /sys failed : 16
>   mount: error 6 mounting ext2
>   mount: error 2 mounting none
>   switchroot: mount failed: 22
>   umount /initrd/dev failed: 2
>   Kernel panic - not syncing: Attempted to kill init!
> 
> Thank you very much for your prompt rescue!

I doubt you'll find any help on the subject on the lists you posted to.
Those are kernel development lists and you have a distribution-related
problem, and with a very old kernel. Maybe searching the distribution's
archives or bugzilla will bring you to someone with the same problem ?

Regards,
Willy

