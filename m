Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXFQFjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXFQFjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 01:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbXFQFjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 01:39:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbXFQFjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 01:39:07 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706162310.24726.dhazelton@enter.net>
	<orejkbkyai.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706170023.03209.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 02:38:43 -0300
In-Reply-To: <200706170023.03209.dhazelton@enter.net> (Daniel Hazelton's message of "Sun\, 17 Jun 2007 00\:23\:02 -0400")
Message-ID: <ory7ijjg2k.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Sunday 17 June 2007 00:19:49 Alexandre Oliva wrote:
>> On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
>> > On Saturday 16 June 2007 21:54:56 Alexandre Oliva wrote:
>> >> There may be laws that require certification or limitations on the
>> >> user.  Manufacturer giving up the ability to make modifications would
>> >> address this, or *perhaps* arranging for user and manufacturer to each
>> >> hold half of the key needed to run a modification (which might comply
>> >> with the GPLv3dd4 terms, IANAL).
>> >
>> > It doesn't. The GPLv3 (dd4) makes that very clear. See the quote below.
>> 
>> You left out the relevant bit:
>> 
>> this requirement does not apply if neither you nor any third party
>> retains the ability to install modified object code on the User
>> Product (for example, the work has been installed in ROM).

> Ah, but giving the user half the key doesn't mean they still don't have access 
> to the entire key. QED: Giving people half the key won't cut it under the 
> GPLv3 (dd4)

I meant really giving, rather than giving a copy, or giving the
original and keeping a copy.

You could make it require a pair of signatures, one from the vendor,
that the vendor keeps, one from the user, that the vendor never sees,
too.  Like some bank PINs, it gets generated, used to generate some
hash (the signature for the initial installation), printed in an
envelope for you and stored in the package along with the machine.  Or
something like that.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
