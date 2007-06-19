Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbXFSSXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbXFSSXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbXFSSXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:23:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbXFSSXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:23:24 -0400
To: Anders Larsen <al@alarsen.net>
Cc: david@lang.hm, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <orbqfdavpn.fsf@oliva.athome.lsd.ic.unicamp.br>
	<1182244240l.11262l.0l@ecxwww1.reanet.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 15:23:00 -0300
In-Reply-To: <1182244240l.11262l.0l@ecxwww1.reanet.de> (Anders Larsen's message of "Tue\, 19 Jun 2007 11\:10\:40 +0200")
Message-ID: <orfy4n3it7.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Anders Larsen <al@alarsen.net> wrote:

> On 2007-06-18 21:50:12, Alexandre Oliva wrote:
>> Given the ROM exception in GPLv3, I guess you could seal and
>> anti-tamper it as much as you want, and leave the ROM at such a place
>> in which it's easily replaceable but with signature checking and all
>> such that the user doesn't install ROM that is not authorized by you.

> The manufacturer must be able to _remotely_ update the device
> firmware, so as I see it (IANAL), Tivoisation _is_ a requirement.

If you take the Wikipedia definition of Tivoization, you'll see it's
about copyleft software only, and no law mandates the use of copyleft
software.  There's no end to bad laws, but a law that mandated the use
of copyleft (=> free) software and at the same time prohibited
modifications by the user would be a very contradictory one.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
