Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYGOMr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYGOMr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYGOMro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:47:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42073 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbYGOMro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:47:44 -0400
Subject: Re: From 2.4 to 2.6 to 2.7?
From: Kasper Sandberg <lkml@metanurb.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
	 <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
	 <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
	 <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 14:41:55 +0200
Message-Id: <1216125715.10312.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 19:47 -0700, Linus Torvalds wrote:
> 
> On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
> > >
<snip>
> Let the bike-shed-painting begin.
> 
> (I had planned on taking this up at the kernel summit, where the shed 
> painting is at least limited to a much smaller audience, but since you 
> asked..)

I like the current numbering fine.. my suggestion is to keep the current
model, there are various reasons

1: it requires no effort
2: various things doesent break
3: naming isnt _THAT_ important

then you could increment the major number once something very important
happens, such as going to 2.8 when the removal of the BKL or something.


mvh.
Kasper Sandberg

