Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbXFNCro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbXFNCro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbXFNCrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:47:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXFNCrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:47:36 -0400
To: Chris Adams <cmadams@hiwaay.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no>
	<fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no>
	<fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no>
	<fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no>
	<fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no>
	<20070614013214.GA1124293@hiwaay.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 13 Jun 2007 23:46:50 -0300
In-Reply-To: <20070614013214.GA1124293@hiwaay.net> (Chris Adams's message of "Wed\, 13 Jun 2007 20\:32\:14 -0500")
Message-ID: <or4plbjlr9.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Chris Adams <cmadams@hiwaay.net> wrote:

> Once upon a time, Alexandre Oliva  <aoliva@redhat.com> said:
>> if you distribute copies of such a program, [...]
>> you must give the recipients all the rights that you have

>> So, TiVo includes a copy of Linux in its DVR.  

>> TiVo retains the right to modify that copy of Linux as it sees fit.

>> It doesn't give the recipients the same right.

> Sure it does; you received a program (the kernel) and you can modify it.

If I take the software I received, build it and install it on the same
hardware, it won't run.  Something is missing in the source code I
received, I guess..

If I make changes to the source code, build it, and install it on that
same computer, it won't run.  How is that being able to modify *that*
copy of the program?

If TiVo makes the same changes, builds tehm, and installs it on my
computer, it will run just fine.  How are they passing on the right
they had to me?

> You also received hardware; they don't support modification of that.

They don't have to support them.  They don't have to help me if it
breaks.  But if they can do it and I can't, they're failing to comply
with the spirit of the GPL.

> Nowhere in the license does it say they have to, because the license
> only covers the program.

They can't distribute the program while imposing restrictions on
modification not present in the software license itself.

> Or are you claiming that putting software on hardware makes the result a
> derivative work?  I think it falls under the "mere aggregation" clause.

I tend to agree, in this particular case, but IANAL.  I don't rule out
derivative works in future attempts to find loopholes in the GPL.

> What if TiVo had put the kernel in a burned-in ROM

Then they wouldn't have the ability to change it any more, so there
wouldn't be such a right to pass on to the users.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
