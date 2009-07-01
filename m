Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZGATUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZGATUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZGATUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:20:01 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:44073 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZGATUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:20:00 -0400
Message-ID: <4A4BB6D5.4030203@billgatliff.com>
Date: Wed, 01 Jul 2009 14:19:49 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hui Zhu <teawater@gmail.com>, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       dhowells@redhat.com, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, stable@kernel.org
Subject: Re: [PATCH] Fix the multithread program core thread message error
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>	<20090701005437.GA5856@cr0.nay.redhat.com>	<daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>	<20090701045102.GA6076@cr0.nay.redhat.com>	<daef60380906302321n681b8092k32c468ae281f4fbb@mail.gmail.com> <20090701120519.d5b1ed78.akpm@linux-foundation.org>
In-Reply-To: <20090701120519.d5b1ed78.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
> I'd have though that having gdb produce crap for all the threads would
> be fairly irritating to ARM developers and hence we should backport
> this.  But perhaps it doens't affect many people, dunno.
>
> What do poeple think?
>   

Not backporting would provide an incentive for people to step up to a
more modern kernel.  :)

One can always backport later if the situation really requires it.  I
say let it be.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com


