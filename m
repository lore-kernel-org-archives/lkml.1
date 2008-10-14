Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYJNQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYJNQK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYJNQKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:10:50 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51969 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbYJNQKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:10:50 -0400
Date: Tue, 14 Oct 2008 19:09:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       acme@ghostprotocols.net
Subject: Re: [PATCH v0] header redux: remove sched.h from interrupt.h
Message-ID: <20081014160940.GA30381@cs181140183.pp.htv.fi>
References: <20081014154510.GA14588@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081014154510.GA14588@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 07:45:10PM +0400, Alexey Dobriyan wrote:
> I'm going to send this slightly before -rc1 or right after -rc1.
> 
> It lives at
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/headers.git headers
> 
> Further reduction ideas are welcome.

Breaking the #include cycle between mm.h and vmstat.h would be nice...

>...
> [insert cross-compile status here]

I can give it a run with all defconfigs if you want.

>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

