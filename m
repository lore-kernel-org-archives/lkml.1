Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXCSQDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXCSQDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXCSQDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:03:45 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1300 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030293AbXCSQDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:03:44 -0400
Message-ID: <45FEB45E.4030500@rtr.ca>
Date: Mon, 19 Mar 2007 12:03:42 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com>	 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>	 <200703172048.46267.kernel@kolivas.org> <1174125534.7734.2.camel@Homer.simpson.net>
In-Reply-To: <1174125534.7734.2.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2007-03-17 at 20:48 +1100, Con Kolivas wrote:
> 
>> The most frustrating part of a discussion of this nature on lkml is that 
>> earlier information in a thread seems to be long forgotten after a few days 
>> and all that is left is the one reporter having a problem.
> 
> One?  I'm not the only person who reported regression.

Ditto here.  I'm not the only one after all!
Reverted back to stock scheduler, and desktop is interactive again.

-ml
