Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421Ab0ATOUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0ATOUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999Ab0ATOUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:20:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31075 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0ATOUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:20:49 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 09:20:48 EST
Date: Wed, 20 Jan 2010 15:09:55 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event description in
 sysfs
In-reply-to: <1263996080.4283.1064.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Iles <jamie.iles@picochip.com>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, mingo@elte.hu, m.szyprowski@samsung.com,
       linux-arm-kernel@lists.infradead.org,
       Tomasz Fujak <t.fujak@samsung.com>
Message-id: <op.u6t4atd07p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
 <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus>
 <20100120133145.GE4089@wear.picochip.com> <1263994779.4283.1057.camel@laptop>
 <20100120135553.GA22897@n2100.arm.linux.org.uk>
 <1263996080.4283.1064.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 15:01:20 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> It seems to me userspace might care about the exact platform they're
> running on.

In my humble opinion, user space should never care about platform it's
running on.  Interfaces provided by kernel should suffice to implement
abstraction layer between user space and hardware.  If we abandon that
we're back in DOS times.  But hey, again, that's just my opinion.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
