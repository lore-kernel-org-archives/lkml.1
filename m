Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXFNT3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXFNT3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbXFNT30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:29:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbXFNT3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:29:24 -0400
To: Valdis.Kletnieks@vt.edu
Cc: Daniel Hazelton <dhazelton@enter.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706131946.15714.dhazelton@enter.net>
	<20070614021619.381331dc@the-village.bc.nu>
	<200706132129.52736.dhazelton@enter.net>
	<or8xanjm1c.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9114.1181792906@turing-police.cc.vt.edu>
	<or7iq7hy2r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20019.1181843459@turing-police.cc.vt.edu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 16:29:03 -0300
In-Reply-To: <20019.1181843459@turing-police.cc.vt.edu> (Valdis Kletnieks's message of "Thu\, 14 Jun 2007 13\:50\:59 -0400")
Message-ID: <orbqficp34.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Valdis.Kletnieks@vt.edu wrote:

> On Thu, 14 Jun 2007 03:03:40 -0300, Alexandre Oliva said:
>> On Jun 14, 2007, Valdis.Kletnieks@vt.edu wrote:
>> 
>> > If a company sells you hardware that includes a ROM that contains GPL'ed
>> > software, are they in violation of the GPL if they don't include a ROM burner
>> > in the hardware?  Or are ROM burners like compilers, where you have to supply
>> > your own?
>> 
>> this requirement does not apply if neither you nor any third party
>> retains the ability to install modified object code on the User
>> Product (for example, the work has been installed in ROM).

> Do they have to provide a ROM burner if the ROM is socketed rather than
> soldered into place?

Of course not.  They just can't impose restrictions on your obtaining
a ROM burner and doing the work yourself.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
