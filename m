Return-Path: <linux-kernel-owner+w=401wt.eu-S932198AbXBOJgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbXBOJgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 04:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbXBOJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 04:36:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54383 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198AbXBOJgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 04:36:32 -0500
Message-ID: <45D4299D.6000906@garzik.org>
Date: Thu, 15 Feb 2007 04:36:29 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86: Unify pcspeaker platform device code between i386/x86-64
References: <200702150901.l1F910lp023036@hera.kernel.org>
In-Reply-To: <200702150901.l1F910lp023036@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=62cc49396e593dd71c6595302bb10b085aefbfa5
> Commit:     62cc49396e593dd71c6595302bb10b085aefbfa5
> Parent:     40d22c1b5675e428b3f3f9a945d0bd62e94ca2f1
> Author:     Andi Kleen <ak@suse.de>
> AuthorDate: Tue Feb 13 13:26:26 2007 +0100
> Committer:  Andi Kleen <andi@basil.nowhere.org>
> CommitDate: Tue Feb 13 13:26:26 2007 +0100
> 
>     [PATCH] x86: Unify pcspeaker platform device code between i386/x86-64
>     
>     Trivial cleanup.
>     
>     Only change is that it is always compiled in now on x86-64 like on i386.
>     
>     Signed-off-by: Andi Kleen <ak@suse.de>

THANK YOU.

It's always seemed broken (though perhaps this was a distro bug?) in 
module form, so I've been compiling it in to get it to work.

	Jeff


