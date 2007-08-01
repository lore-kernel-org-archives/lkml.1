Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXHADxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXHADxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbXHADxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:53:06 -0400
Received: from sandeen.net ([209.173.210.139]:20316 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbXHADxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:53:04 -0400
Message-ID: <46B003A3.1090507@sandeen.net>
Date: Tue, 31 Jul 2007 22:53:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.5 (Macintosh/20070716)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrea Arcangeli <andrea@suse.de>,
       Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <469BF104.1040703@gmail.com> <20070716232755.GD11115@waste.org>	 <20070719001539.GC29728@v2.random>	 <20070719013955.1bedc423@the-village.bc.nu>	 <20070719013358.GD29728@v2.random> <20070719013725.GP11115@waste.org>	 <20070719112436.GG29728@v2.random>	 <20070719124419.48c3d610@the-village.bc.nu>	 <46A9ECD5.3050801@sandeen.net>	 <20070727183807.2d7dbe7b@the-village.bc.nu> <a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
In-Reply-To: <a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 7/27/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> Maybe I should resurrect it & send it out...
> 
> Hmm, something that hooks in not only at do_IRQ time (as the present
> in-mainline stackoverflow check thing)?

No, what I had did only that, so it was still a matter of probabilities...

-Eric

