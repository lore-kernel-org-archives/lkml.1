Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXFNQye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXFNQye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXFNQy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:54:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXFNQy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:54:26 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140305.50095.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 13:52:59 -0300
In-Reply-To: <200706140305.50095.dhazelton@enter.net> (Daniel Hazelton's message of "Thu\, 14 Jun 2007 03\:05\:49 -0400")
Message-ID: <orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> And? There is *absolutely* *nothing* in any version of the GPL *prior* to 3 
> that says that hardware cannot impose restrictions.

It's not that the hardware is deciding to impose restrictions on its
own.  It's the hardware distributor that is deciding to use the
hardware to impose restrictions on the user.  Seems like a violation
of section 6 of GPLv2 to me.

> What the GPL *does* say is that you can't "add additional
> restrictions to the license"

Not quite.  It's more general than that:

  You may not impose any further restrictions on the recipients'
  exercise of the rights granted herein.

>> > So take another example: I obviously distribute code that is copyrighted
>> > by others under the GPLv2. Do I follow the GPLv2? I sure as hell do! But
>> > do I give you the same rights as I have to modify the copy on
>> > master.kernel.org as I have? I sure as hell DO NOT!

>> That's an interesting argument.

>> People don't get your copy, so they're not entitled to anything about
>> it.

>> When they download the software, they get another copy, and they have
>> a right to modify that copy.

> But you get the TiVO corporations copy of the software?

Yes.  The customer gets the copy that TiVO stored in the hard disk in
the device it sells.  And it's that copy that the customer is entitled
to modify because TiVO is still able to modify it.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
