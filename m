Return-Path: <linux-kernel-owner+w=401wt.eu-S2992457AbXDCWkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992457AbXDCWkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992458AbXDCWkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:40:24 -0400
Received: from smtp.ono.com ([62.42.230.12]:44808 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992457AbXDCWkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:40:23 -0400
Date: Wed, 4 Apr 2007 00:40:05 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
Message-ID: <20070404004005.2f21d514@werewolf-wl>
In-Reply-To: <20070402224745.71a25af7.akpm@linux-foundation.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.1cvs80 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 22:47:45 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
> - The oops in git-net.patch has been fixed, so that tree has been restored. 
>   It is huge.
> 
> - Added the device-mapper development tree to the -mm lineup (Alasdair
>   Kergon).  It is a quilt tree, living at
>   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> 
> - Added davidel's signalfd stuff.
> 

Something strange happens to me with this kernel.
Gnome Screensaver hangs the box. Locked solid, no atl-sysrq-raw,
no ssh. Nada.
Do not know if it's itself, or something in X dpms.

Somebody else ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam08 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
