Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXCKUmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXCKUmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXCKUmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:42:33 -0400
Received: from keil-draco.com ([216.193.185.50]:50875 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752366AbXCKUmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:42:32 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Style Question
Date: Sun, 11 Mar 2007 16:41:51 -0400
User-Agent: KMail/1.9.6
Cc: Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com> <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111641.52066.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 16:35:50 Jan Engelhardt wrote:
> On Mar 11 2007 22:15, Cong WANG wrote:
> > Another question is about NULL. AFAIK, in user space, using NULL is
> > better than directly using 0 in C. In kernel, I know it used its own
> > NULL, which may be defined as ((void*)0), but it's _still_ different
> > from raw zero.
>
> In what way?
>
> >So can I say using NULL is better than 0 in kernel?
>
> On what basis? Do you even know what NULL is defined as in
> (C, not C++) userspace? Think about it.

IIRC, the glibc and GCC headers define NULL as (void*)0  :)

>
>
> Jan


