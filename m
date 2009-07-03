Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZGCCux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZGCCux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZGCCuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:50:44 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57064 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZGCCun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:50:43 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tridge@samba.org, Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
	<20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	<19019.27736.647500.497114@samba.org>
	<20090701154151.7f45abad@lxorguk.ukuu.org.uk>
	<19020.12748.348370.708306@samba.org>
	<20090702113200.39a15f21@lxorguk.ukuu.org.uk>
	<19020.43585.375900.217202@samba.org>
	<20090702175627.580bdebc@lxorguk.ukuu.org.uk>
Date: Fri, 03 Jul 2009 11:50:40 +0900
In-Reply-To: <20090702175627.580bdebc@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Thu, 2 Jul 2009 17:56:27 +0100")
Message-ID: <87skhe4gzj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> To my mind we need to be careful of three things
>
> - Harming the kernel to work around a potentially country specific
>   unproven problem for the benefit of a few big corporations only

My choice is to provide the option of those to users. I'm not saying to
ripping out the code for some users.

> - Getting into situations where big companies behind closed doors make
>   unaccountable decisions about a project they do not own

Now, I'm not working for any companies. I can say there is no closed
doors for me.

> - Setting trends for country specific fixups. There are a lot of
>   countries and if we keep the US happy we have to keep China happy and
>   so it goes on. Big corporations employ armies of specialists for these
>   purposes and make the gain from it. The community doesn't so it should
>   no more carry the pain of it than of long term stable releases and
>   supporting five year old vendor kernels

I'm just thinking about users. If vendors shipped the buggy code like
first buggy patch, I just thought it's more bad for our users. That's
all.

If there is community decision, I'll be really glad to follow it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
