Return-Path: <linux-kernel-owner+w=401wt.eu-S1764554AbXFRTJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764554AbXFRTJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbXFRTI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:08:58 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59773
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286AbXFRTI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:08:57 -0400
Date: Mon, 18 Jun 2007 12:07:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Anders Larsen <al@alarsen.net>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <or1wg9ccyd.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706181202580.12717@asgard.lang.hm>
References: <1182156596l.29108l.0l@ecxwww1.reanet.de>
 <or1wg9ccyd.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Alexandre Oliva wrote:

> On Jun 18, 2007, Anders Larsen <al@alarsen.net> wrote:
>
>> On Sat, 16 Jun 2007 22:54:56 -0300, Alexandre Oliva wrote:
>>> I don't know any law that requires tivoization.
>
>> Not exactly laws, but pretty close:
>
>> Credit-card payment terminals are subject to strict security
>> certification, where it has to be ensured that
>
>> a) the user cannot tinker with the device without rendering it unusable
>> for its original purpose (electronic payments), and
>
> I think GPLv3 has that covered:
>
>  Network access may be denied when the modification itself materially
>  and adversely affects the operation of the network or violates the
>  rules and protocols for communication across the network.
>
> I've been sufficiently annoyed by credit card transactions that cannot
> be completed for network-down reasons that I believe such devices
> depend on network access to perform the original purpose, and even
> though IANAL I think that cutting off network access in case the
> software no longer complies with the regulations is permitted by the
> license.

you misunderstand the reason for these rules.

they want to prevent anyone from modifying the credit card machine to 
store copies of all the card info locally. this modification would not 
affect what goes over the wire at all. so your exception doesn't apply

>> b) the manufacturer is able to update the device _in_ _the_ _field_.
>
> If the above is not enough, you could always use ROM.  Sure, if you
> can replace the ROM, so can the user, and this just goes to show how
> short-sighted the alleged prohibitions on user tinkering with the
> software are.  Sure, it would be more costly, but it's not like the
> law (or the agreements in place) *mandate* tivoization.

you don't really answer this issue. since these boxes are required to be 
sealed and physically anti-tamper, changing the ROM is not acceptable.

David Lang
