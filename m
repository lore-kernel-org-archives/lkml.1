Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYGDVcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYGDVcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYGDVco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:32:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38390 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751714AbYGDVcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:32:43 -0400
Date: Fri, 4 Jul 2008 22:14:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joe Peterson <joe@skyrush.com>, Elias Oltmanns <eo@nebensachen.de>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080704221457.1f147225@lxorguk.ukuu.org.uk>
In-Reply-To: <871w29s5u2.fsf@basil.nowhere.org>
References: <48661488.10304@gmail.com>
	<87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
	<871w29s5u2.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Doesn't make sense to me. And yes I see this here regularly and it started
> at some point.

Lets have some profiles and TSC numbers then. I'm happy to believe some
specific combination of hardware/timing shows up a real problem but
looking at the tiny amount of code involved I can see no sane explanation
as to why at this point.

I'm not going to look further into it without real serious data from
people seeing it.
