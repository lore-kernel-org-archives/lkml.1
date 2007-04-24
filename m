Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbXDXILA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbXDXILA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXDXILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:11:00 -0400
Received: from smtp.ono.com ([62.42.230.12]:61558 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754540AbXDXIK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:10:58 -0400
Date: Tue, 24 Apr 2007 10:10:41 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070424101041.2fb2d9e0@werewolf-wl>
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1cvs18 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Apr 2007 14:35:59 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/
> 
> 
> - Lots of x86 updates
> 

Has somthing related with PTY's changed in this kernel ?
I have to enable legacy PTY handling in a couple boxes to get ssh working.
If not, I had openpty() errors and nor sshd nor virtual terminals (aterm) were
able to get a terminal.

User space (udev) is the same in three boxes and one works and two fail.
I had /dev/ptmx everywhere and /dev/pts mounted

Any idea ?
TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.20-jam10 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
