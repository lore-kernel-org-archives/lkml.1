Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbXFNTOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbXFNTOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXFNTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:13:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbXFNTNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:13:53 -0400
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132121.04532.dhazelton@enter.net>
	<orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132304.21984.dhazelton@enter.net>
	<20070614112329.3645c397@the-village.bc.nu>
	<20070614103846.GA7902@elte.hu>
	<or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<46718044.1040108@nortel.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 16:13:31 -0300
In-Reply-To: <46718044.1040108@nortel.com> (Chris Friesen's message of "Thu\, 14 Jun 2007 11\:52\:04 -0600")
Message-ID: <orodjicpt0.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, "Chris Friesen" <cfriesen@nortel.com> wrote:

> Alexandre Oliva wrote:
>> But see, I'm not talking about getting permission to hack the
>> hardware.  I'm only talking about getting permission to hack the Free
>> Software in it.

> No you're not...you're talking about being able to hack the software
> *and load it back onto the original hardware*.

Yes.  You wouldn't impose restrictions on modifying the software like
that, now would you?  Even though the GPL says you can't impose
further restrictions on modification and distribution.

>> It's your position that mingles the issues and permits people to use
>> the hardware to deprive users of freedom over the software that
>> they're entitled to have.

> The software license controls the software.  If the hardware has
> restrictions on it that limit what software it will run, then that is
> unrelated to the software license.

As in, the license controls the software.  If a patent creates
restrictions that limit what you can do with the software, then that
is unrelated to the software license.

As in, the license controls the software.  If a discriminatory
contract limits what you can do with the software, then that is
unrelated to the software license.

As in, the license controls the software.  If I send you the source
code, but it happens to be protected by a key that only the hardware
can decode, and it won't decode for you, then that is unrelated to the
software license.

Is that so, really?

> There is nothing stopping you from taking the code for the tivo,
> modifying it, distributing it, or even running it on other hardware.

True.  But TiVO is still imposing further restrictions on how I can
modify the software stored in their device, while reserving that
ability to itself.  This is wrong.  This is not "in kind".  This is
not "tit-for-tat".  Tit-for-tat is: if they can, then I can too, and
if I can't, then they can't either.

> Suppose I had some machine that will only run microsoft-signed
> binaries. Would it be at all related to any software license that this
> machine won't let me run linux?

That would be an unfortunate machine to have, but if Linux or some
other GPLed software was not shipped in it, then I don't see how this
is relevant to this discussion.  It's not about the hardware, it's
about the software in it, and about passing on the freedoms related
with it.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
