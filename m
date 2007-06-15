Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbXFOT1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbXFOT1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXFOT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:27:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbXFOT1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:27:12 -0400
To: Bron Gondwana <brong@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132304.21984.dhazelton@enter.net>
	<20070614112329.3645c397@the-village.bc.nu>
	<20070614103846.GA7902@elte.hu>
	<or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614195517.GA4933@elte.hu>
	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
	<orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615072322.GA7594@brong.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 16:26:34 -0300
In-Reply-To: <20070615072322.GA7594@brong.net> (Bron Gondwana's message of "Fri\, 15 Jun 2007 17\:23\:22 +1000")
Message-ID: <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:

> What happens if you're debugging something you think is a bug in the
> Linux kernel and then you run bang into some interactions that make you
> think the bug might be in the BIOS instead.

> have denied your freedom to modify and debug the system they sold you

If the bug is in the non-GPLed BIOS, not in the GPLed code, too bad.
One more reason to dislike non-Free Software.

The freedom the GPL defends is not the freedom to modify and debug the
system, but rather the covered software.

Now, if you find evidence that the "bug" is actually intentionally put
there to stop you from doing what you wanted with the software, then
there's clearly a violation of the spirit of the license, and you
might even have a case of copyright infringement, but IANAL.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
