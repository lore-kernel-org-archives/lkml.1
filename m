Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbXFOVUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbXFOVUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbXFOVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:20:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992AbXFOVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:20:12 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
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
	<or645q6jp4.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615181724.GO10008@csclub.uwaterloo.ca>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 18:19:44 -0300
In-Reply-To: <20070615181724.GO10008@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Fri\, 15 Jun 2007 14\:17\:24 -0400")
Message-ID: <or4pl8yky7.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Thu, Jun 14, 2007 at 11:21:59PM -0300, Alexandre Oliva wrote:
>> Consider egg yolk and egg shells.
>> 
>> I produce egg yolk.  I give it to you under terms that say "if you
>> pass this on, you must do so in such a way that doesn't stop anyone
>> from eating it"
>> 
>> 
>> You produce egg shells.  You carefully construct your shell around the
>> egg yolk and some white you got from a liberal third party.
>> 
>> 
>> Then you sell the egg shells, with white and yolk inside, under
>> contracts that specify "the shell must be kept intact, it can't be
>> broken or otherwise perforated".

> It would be more like not telling you how to change the egg yolk while
> still having a working egg.

This might be more like GPLv3, or it might not.  But it still misses
the point.

The point is to show that the egg yolk license still is about the egg
yolk license, even though its effects do limit what the egg shell
manufacturer can do with that particular egg yolk.

I.e., the GPL is still about the software, and the hardware
manufacturer can't claim "but this is the hardware!" to escape
obligations determined by its choice of the GPL software.

>> Are you or are you not disrespecting the terms that apply to the yolk?

> Very bad comparison.  

Very bad understanding of the intent of the argument, and failing to
answer the relevant question ;-)

> What if I want to run a program that takes 512MB ram and the hardware
> guys put in 128MB.  Now they are impeding me doing the change I wanted
> to do to the software.

*Why* did they make this decision?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
