Return-Path: <linux-kernel-owner+w=401wt.eu-S936470AbXGRAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936470AbXGRAXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbXGRAXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:23:16 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34205 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbXGRAXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:23:15 -0400
Message-ID: <469D5D2A.9000506@gmail.com>
Date: Wed, 18 Jul 2007 02:22:02 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Chinner <dgc@sgi.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8Gj55-hJ-5@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it>	 <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>	 <469A5D7C.5010904@gmail.com>	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>	 <469BF104.1040703@gmail.com>	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>	 <20070716235438.1bdd0722@the-village.bc.nu>	 <20070717170127.GJ11781@holomorphy.com> <9a8748490707171639r41c085bfh857c5047a792dd0@mail.gmail.com>
In-Reply-To: <9a8748490707171639r41c085bfh857c5047a792dd0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2007 01:39 AM, Jesper Juhl wrote:

> On 17/07/07, William Lee Irwin III <wli@holomorphy.com> wrote:

>> At hch's suggestion I rewrote the separate IRQ stack configurability
>> patch into one making IRQ stacks mandatory and unconfigurable, and
>> hence enabled with 8K stacks.
>>
> For what it's worth, that sounds good to me - like something that we
> would want merged.

Yes, seperate IRQ stacks make eminent sense in their own right.

Andrea Arcangeli's current thread on soft pages:

http://lkml.org/lkml/2007/7/6/346

is also interesting though in the context of 1-page stacks.

Rene.

