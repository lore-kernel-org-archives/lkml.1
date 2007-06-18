Return-Path: <linux-kernel-owner+w=401wt.eu-S1761852AbXFRA6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852AbXFRA6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXFRA6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:58:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbXFRA6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:58:09 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: mea culpa on the meaning of Tivoization
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
	<ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617122025.5a444e62@the-village.bc.nu>
	<orsl8qh1mq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617211853.400712e0@the-village.bc.nu>
	<orodjefgrc.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617222123.0412f740@the-village.bc.nu>
	<orabuyfa7i.fsf_-_@oliva.athome.lsd.ic.unicamp.br>
	<20070618005041.6c51a368@the-village.bc.nu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 21:56:07 -0300
In-Reply-To: <20070618005041.6c51a368@the-village.bc.nu> (Alan Cox's message of "Mon\, 18 Jun 2007 00\:50\:41 +0100")
Message-ID: <orabuydqs8.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> > In practical terms it does since a recall/replacement in the event of
>> > rule changes is a bit impractical
>> 
>> Indeed.  But that's not a legal requirement, it's an economic reason.

> Cynical Economists would argue 'legal requirements' are just changes to
> the cost of the various economic options. Sometimes when I look at
> Microsoft's approach to various cases it seems they think that way too.

I guess this depends to some point on the kind of penalties you face.
If they're only economic, then yes.  If you may end up going to jail
or some such, I think the picture gets different.  But yes, that's a
way to see it, and I know we're not alone in perceiving some behaviors
that way.

> I can tell you how to upgrade it ("you can't") yet I as the manufacturer
> can issue new units with modified code so I still control it even though
> it is meant to be "free"

The GPL has never prohibited the distribution of software in ROM, just
like it's never prohibited the fixation of software in CD-ROMs.  So
explicitly permitting is not a step back in terms of defending
freedoms, even if there might be something to do that would advance
freedoms in this field.

Anyhow, AFAIK software in ROM is not non-Free Software.  That it's
impossible to modify/replace/whathaveyou it is not the result of a
restriction that someone is imposing on you.

It's the difference between "you can't fly because you don't have
wings" and "you won't fly because I've tied your wings".  With tied
wings, you're evidently not free to fly any more.  But if the problem
is that you don't have wings, if you're free and sufficiently
creative, you may be able to invent baloons, airplanes, rockets et al
and overcome the barriers that nature poses for you.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
