Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYDGObk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYDGObk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 10:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbYDGOba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 10:31:30 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44706 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYDGOb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 10:31:29 -0400
Date: Mon, 7 Apr 2008 07:31:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Lazy <lazy404@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] 2.6.24.4 compilation error
Message-ID: <20080407143107.GC31847@sequoia.sous-sol.org>
References: <efeafa350804070321ka6cbb46pd49a62fc325eb4e0@mail.gmail.com> <47FA012C.7000509@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FA012C.7000509@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gabriel C (nix.or.die@googlemail.com) wrote:
> Lazy wrote:
> > kernel/built-in.o: In function `update_wall_time':
> > (.text+0x23796): undefined reference to `__umoddi3'
> > kernel/built-in.o: In function `update_wall_time':
> > (.text+0x237b6): undefined reference to `__udivdi3'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> You'll need this patch :
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=38332cb98772f5ea757e6486bed7ed0381cb5f98


This is already queued for 2.6.24.5

thanks,
-chris
