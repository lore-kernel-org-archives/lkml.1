Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbXFQSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbXFQSyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbXFQSyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:54:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592AbXFQSyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:54:19 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070614122031.4751a52b@the-village.bc.nu>
	<20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
	<20070615120926.GD6269@elte.hu>
	<orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615214804.GC4996@elte.hu>
	<or3b0svjc5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617073820.GA6267@elte.hu>
	<ory7ijhu4q.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617150819.GI14788@delft.aura.cs.cmu.edu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 15:53:22 -0300
In-Reply-To: <20070617150819.GI14788@delft.aura.cs.cmu.edu> (Jan Harkes's message of "Sun\, 17 Jun 2007 11\:08\:19 -0400")
Message-ID: <ork5u2h0pp.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> On Sun, Jun 17, 2007 at 05:17:57AM -0300, Alexandre Oliva wrote:
>> Just make the tivoization machinery require two keys: one that the
>> vendor keeps, one that the vendor gives to the user (maybe without
>> ever knowing it).  Neither one can install modifications alone, but
>> the user can approve modifications by the vendor, and the vendor can
>> approve modifications by the user.  This is still not ideal, but it at
>> least doesn't permit the vendor to remove features from under the
>> user.

> So what features has Tivo removed (or threatened to remove) from the GPL
> licensed parts?

Why does it matter?  The point is that a tivoizer *could* do that.

> So Google is using Linux right. What if they remove some feature?

Are you claiming Google is tivoizing something in their internal
infrastructure?  They're not distributing or conveying that software,
so, nothing wrong with that.

Or are you talking about their search appliance, which I know nearly
nothing about?

> So if Tivo would allow you to boot your own kernel, but keeps the
> harddisk encrypted if the booted kernel does not have the right
> signature?

  The information must suffice to ensure that the continued
  functioning of the modified object code is in no case prevented or
  interfered with solely because modification has been made.

> And how is that any different from taking an off-the-shelf PC and
> booting your own kernel with Tivo's modifications?

TiVo did not sell me that off-the-shelf PC with the Free Software in
it.  It (hypothetically) sold me a computer with technical measures
meant to restrict my ability to adapt the software it shipped to my
own needs and to run it for any purpose, while it can still do that.
That's a difference.

>>   this requirement does not apply if neither you nor any third
>>   party retains the ability to install modified object code on the
>>   User Product

> So they keep the system locked down, but include perl/python/emacs and
> distribute updates in the form of scripts/source code which are either
> interpreted or compiled to a ramfs filesystem at boot. Time to add
> another exception?

Intent behind this?: weasel out of the obligations of the license.
Anyone, probably even a US court, might very well see it that way.

They retain the ability to modify the software, so they ought to pass
it on to the user.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
