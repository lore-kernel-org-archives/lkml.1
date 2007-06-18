Return-Path: <linux-kernel-owner+w=401wt.eu-S1765608AbXFRTux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765608AbXFRTux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbXFRTup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:50:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbXFRTuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:50:44 -0400
To: david@lang.hm
Cc: Anders Larsen <al@alarsen.net>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <1182156596l.29108l.0l@ecxwww1.reanet.de>
	<or1wg9ccyd.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706181202580.12717@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 16:50:12 -0300
In-Reply-To: <Pine.LNX.4.64.0706181202580.12717@asgard.lang.hm> (david@lang.hm's message of "Mon\, 18 Jun 2007 12\:07\:57 -0700 \(PDT\)")
Message-ID: <orbqfdavpn.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, david@lang.hm wrote:

> they want to prevent anyone from modifying the credit card machine to
> store copies of all the card info locally.

I see.  Thanks for enlightening me.

> you don't really answer this issue. since these boxes are required to
> be sealed and physically anti-tamper, changing the ROM is not
> acceptable.

Given the ROM exception in GPLv3, I guess you could seal and
anti-tamper it as much as you want, and leave the ROM at such a place
in which it's easily replaceable but with signature checking and all
such that the user doesn't install ROM that is not authorized by you.

This would be against the spirit of the GPL, but I don't know whether
it could be interpreted as disrespecting some other provision of the
letter of GPLv3.  Maybe it could.  Something for lawyers to decide,
and IANAL.  Something the GPLv3 folks would like to take into account,
even if the outcome may be not quite what you'd like ;-)

Thanks again for the information,

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
