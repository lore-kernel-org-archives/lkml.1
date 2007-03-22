Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXCVX1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXCVX1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934147AbXCVX1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:27:18 -0400
Received: from smtp.ono.com ([62.42.230.12]:62890 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933413AbXCVX1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:27:17 -0400
Date: Fri, 23 Mar 2007 00:27:09 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070323002709.3d45aa19@werewolf-wl>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1cvs36 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 20:56:23 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 

Is anybody having problems with optical drives and this kernel ?
I can't get my dvdrw to spit any events to udevmonitor. If I mount it
manually everything works fine.

Perhaps the problem is in hal/g-v-m or anything else, but I suppose that
udevmonitor receives events directly from kernel, isn't it ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
