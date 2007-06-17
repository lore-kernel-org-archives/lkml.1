Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbXFQBzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbXFQBzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 21:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXFQBzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 21:55:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbXFQBzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 21:55:17 -0400
To: Bron Gondwana <brong@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
	<orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615072322.GA7594@brong.net>
	<orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616021630.GA30660@brong.net>
	<orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616103130.GD32405@brong.net>
	<orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616233251.GA17270@brong.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 16 Jun 2007 22:54:56 -0300
In-Reply-To: <20070616233251.GA17270@brong.net> (Bron Gondwana's message of "Sun\, 17 Jun 2007 09\:32\:51 +1000")
Message-ID: <ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007, Bron Gondwana <brong@fastmail.fm> wrote:

> I obviously wasn't clear enough.  The only way to come into complience
> with GPL3dd4 is to reduce your ability to fix things or grant everyone
> else the ability to mess with things.  This severely restricts you from
> doing _anything_ in certain problem spaces due to local laws on the
> topic, even if you're an otherwise good actor who is making worthwhile
> source code contributions to the rest of the community.

I don't know any law that requires tivoization.

There may be laws that require certification or limitations on the
user.  Manufacturer giving up the ability to make modifications would
address this, or *perhaps* arranging for user and manufacturer to each
hold half of the key needed to run a modification (which might comply
with the GPLv3dd4 terms, IANAL).

There may be business models that require the ability to make changes.
Then it's fair to enable the user to make changes as well, such that
they don't become dependent on the vendor, or even have their
1st-generation TiVo boxes left out in the cold for a while when the US
changes the DST rules again ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
