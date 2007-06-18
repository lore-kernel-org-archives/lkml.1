Return-Path: <linux-kernel-owner+w=401wt.eu-S1765648AbXFRSxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765648AbXFRSxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764457AbXFRSw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:52:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764029AbXFRSwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:52:55 -0400
To: Anders Larsen <al@alarsen.net>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <1182156596l.29108l.0l@ecxwww1.reanet.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 15:52:26 -0300
In-Reply-To: <1182156596l.29108l.0l@ecxwww1.reanet.de> (Anders Larsen's message of "Mon\, 18 Jun 2007 10\:49\:56 +0200")
Message-ID: <or1wg9ccyd.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Anders Larsen <al@alarsen.net> wrote:

> On Sat, 16 Jun 2007 22:54:56 -0300, Alexandre Oliva wrote:
>> I don't know any law that requires tivoization.

> Not exactly laws, but pretty close:

> Credit-card payment terminals are subject to strict security
> certification, where it has to be ensured that

> a) the user cannot tinker with the device without rendering it unusable
> for its original purpose (electronic payments), and

I think GPLv3 has that covered:

  Network access may be denied when the modification itself materially
  and adversely affects the operation of the network or violates the
  rules and protocols for communication across the network.

I've been sufficiently annoyed by credit card transactions that cannot
be completed for network-down reasons that I believe such devices
depend on network access to perform the original purpose, and even
though IANAL I think that cutting off network access in case the
software no longer complies with the regulations is permitted by the
license.

> b) the manufacturer is able to update the device _in_ _the_ _field_.

If the above is not enough, you could always use ROM.  Sure, if you
can replace the ROM, so can the user, and this just goes to show how
short-sighted the alleged prohibitions on user tinkering with the
software are.  Sure, it would be more costly, but it's not like the
law (or the agreements in place) *mandate* tivoization.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
