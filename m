Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbXFQCA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbXFQCA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 22:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbXFQCAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 22:00:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbXFQCAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 22:00:51 -0400
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <200706132121.04532.dhazelton@enter.net>
	<orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132304.21984.dhazelton@enter.net>
	<20070614112329.3645c397@the-village.bc.nu>
	<20070614103846.GA7902@elte.hu>
	<or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614195517.GA4933@elte.hu>
	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu>
	<20070615011012.6c09066e@the-village.bc.nu>
	<20070615012623.GA25189@elte.hu>
	<20070615101007.0cbfd078@the-village.bc.nu>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<46747D77.6090906@t-online.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 16 Jun 2007 23:00:23 -0300
In-Reply-To: <46747D77.6090906@t-online.de> (Bernd Schmidt's message of "Sun\, 17 Jun 2007 02\:16\:55 +0200")
Message-ID: <orfy4rmjbc.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007, Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> See, that's the problem I have with your arguments.  "Same freedom for
> everyone" is a political slogan.  It is not a reasoned thought.

Well, this is what got us GPLv2.  And the same reasoning is getting us
GPLv3, and it does get hardware manufacturers to think twice instead
of tivoizing hardware.  They can decide between respecting users'
freedoms and encouraging a community of developers around its product,
or they can decide that not letting users change the software is more
important or necessary, and give up the ability to install
modifications without user approval.  If half of the vendors go each
way, we'll get far more contributions in the end, so we're better off.

This is why I think the argument that anti-tivoization won't get us
more "giving back in kind" is irrational and contradictory.

> "Tivo should install ROMs so they don't have more rights than users"

TiVo doesn't have to install ROMs.  It can use the same technical
measures it uses today, then throw away the keys.

Or give the user half of the signing key, or some such.

How bad would this be for them?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
