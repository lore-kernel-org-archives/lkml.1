Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbXLNOo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbXLNOo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXLNOov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:44:51 -0500
Received: from rtr.ca ([76.10.145.34]:3700 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXLNOou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:44:50 -0500
Message-ID: <476296E0.3000709@rtr.ca>
Date: Fri, 14 Dec 2007 09:44:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Arun Thomas <arun.thomas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>  <20071214015315.09829a99.akpm@linux-foundation.org> <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com> <4762586F.8090603@gmail.com> <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.99999.0712141140310.10584@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
..
> Arun, do you have an USB keyboard plugged in ? If not, can you connect
> one and check, whether it changes things or not ?
..

One of my two affected boxes has a USB mouse plugged in,
and it makes no difference one way or another.

No USB keyboards here, though.

Cheers
