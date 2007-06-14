Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbXFNWiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbXFNWiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXFNWh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:37:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbXFNWh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:37:57 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <fa.V8u0BBHrkymrjcYrFArgehF4jRA@ifi.uio.no>
	<fa.98cYXp0MWFizp+AzMAkKWAo+bpE@ifi.uio.no>
	<fa.21pY11gonruis9l1QAvUgcD/c7g@ifi.uio.no>
	<fa.dR+SnekmQGzom7HRgnAyn3+gVkU@ifi.uio.no>
	<20070614205541.GA886803@hiwaay.net>
	<20070614224722.570e093b@the-village.bc.nu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 19:37:48 -0300
In-Reply-To: <20070614224722.570e093b@the-village.bc.nu> (Alan Cox's message of "Thu\, 14 Jun 2007 22\:47\:22 +0100")
Message-ID: <orlkem88n7.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> Activities other than copying, distribution and modification are not
>> covered by this License; they are outside its scope.  The act of
>> running the Program is not restricted, ...
>> 
>> The license does not cover running of the program.  It doesn't restrict
>> it, but it doesn't cover it.  Claiming otherwise is turning the GPL into
>> yet another dreaded EULA.

> For many juridisctions loading from disk into memory is copying and in
> some from memory to CPU cache a second copy. This is one reason as I
> understand it GPLv3 talks about "conveying" - to avoid that mess and
> confusion.

Hmm...  This is interesting.  Let me sidetrack a little bit.

Who would be held liable should the copy not be authorized by the
copyright holder?  The designer of the hardware?  The seller?  The
person who powerer the computer on?  The author of the boot loader (if
I'm talking about the kernel about to be loaded).

> Really irrelevant to the discussion. Tivo's firmware is up to them.
> Whether the resulting system permits them to include GPLv2 software with
> it is what matters.

+1

It all boils down to whether they're keeping their promise to not
impose further restrictions on the exercise of the rights granted in
the license.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
