Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYCZPBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYCZPBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYCZPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:01:31 -0400
Received: from khc.piap.pl ([195.187.100.11]:55223 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYCZPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:01:30 -0400
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3tzj92xq6.fsf@maximus.localdomain>
	<m33aqedg0a.fsf@maximus.localdomain>
	<20080325.161427.71442171.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 26 Mar 2008 16:01:27 +0100
In-Reply-To: <20080325.161427.71442171.davem@davemloft.net> (David Miller's message of "Tue\, 25 Mar 2008 16\:14\:27 -0700 \(PDT\)")
Message-ID: <m3tzitmsvs.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> Kyzysztof, this is the way you behave every time your
> patches don't get looked at as quickly as you would
> like them to.
>
> And this behavior does not trigger us maintainers to
> stop everything we're doing and apply your patches.
>
> In fact it makes us want to review your patches even
> less.
>
> Sending a healthy ping asking if your patches need
> to be resent, etc., is one thing.  But this isn't
> what you're doing here.

I don't know what are you talking about.

- someone broke my drivers, happens from time to time
- I asked about related change and was told about some "out of tree"
  drivers instead
- I had two modules to fix, one took 15 minutes and for the other one
  I had no time at the moment.
- I finally rewrote the other module
- got feedback, corrected it, resent.
- asked if we are including it in 2.6.25 or if we are to make
  temporary Kconfig change instead

What exactly don't you like in my "behaviour"? I didn't invent
synchronous serial devices. Actually, I'm doing it all in my free
time, and I'm sure I can find better things to do in that time.

I accept I may use not the best wording from time to time, I'm not
native English writter.

What is your problem about me?

I'd appreciate it if you point out the precise things I'm doing
wrong.

Thanks.
-- 
Krzysztof Halasa
