Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYGDVhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYGDVhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYGDVgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:36:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35058 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYGDVgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:36:54 -0400
Message-ID: <486E97F2.8020605@firstfloor.org>
Date: Fri, 04 Jul 2008 23:36:50 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Joe Peterson <joe@skyrush.com>, Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com>	<87fxqurqpz.fsf@denkblock.local>	<486E83C3.1040509@skyrush.com>	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>	<871w29s5u2.fsf@basil.nowhere.org> <20080704221457.1f147225@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704221457.1f147225@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Doesn't make sense to me. And yes I see this here regularly and it started
>> at some point.
> 
> Lets have some profiles and TSC numbers then. I'm happy to believe some
> specific combination of hardware/timing shows up a real problem but
> looking at the tiny amount of code involved I can see no sane explanation
> as to why at this point.

Well Elias showed that changing the order made a visible difference.

> I'm not going to look further into it without real serious data from
> people seeing it.

So you're saying multiple independent people suffer from some kind of
hallucination?

-Andi

