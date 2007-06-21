Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbXFUUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbXFUUDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbXFUUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:03:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXFUUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:03:07 -0400
To: david@lang.hm
Cc: jimmy bahuleyan <knight.camelot@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
	<467A6290.80602@gmail.com>
	<orr6o5kxdr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706211055160.31603@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 17:02:52 -0300
In-Reply-To: <Pine.LNX.4.64.0706211055160.31603@asgard.lang.hm> (david@lang.hm's message of "Thu\, 21 Jun 2007 11\:00\:40 -0700 \(PDT\)")
Message-ID: <orlkedjcsz.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, david@lang.hm wrote:

> this is standard dual-licensing, not special just becouse both
> licenses are GPL versions

No, seriously, it's not, it's quite different.

If you dual-license your code between GPLv2 and GPLv3, I could combine
your code with code under GPLv3, distribute it, and if anyone tivoized
your code, I might be able to enforce the anti-tivoization provisions
against the tivoizer.

With a mere permission to combine, I can only enforce these provisions
over my own code.


I see that, for tivoization, the end result is very much the same as
an all-GPL, although the tivoizer still has the option of removing the
GPLv3 code and hoping GPLv2's implicit anti-tivoization provisions are
not enforced.  This would be just undoing the additional cooperation
that this additional permission would have provided.

However, for other GPLv3 defenses, it would make a difference.  For
example, on the patent licenses that are implicit in GPLv2 and
explicit in GPLv3.

> and for people who don't like one or the other of the two licenses
> this will not be acceptable becouse it would allow someone else to
> take their work, modify it a bit, and release the result only under
> the license that they don't like

Which is precisely why I suggested this approach of permission to
combine, rather than as dual licensing.  Because then nobody could do
what you say.

> one of the big problems that people don't realize is that if it takes
> GPLv3+ exception to be compatible with the apache license

For the record, it doesn't, GPLv3 is going to be compatible with the
apache 2.0 license, no additional exceptions needed.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
