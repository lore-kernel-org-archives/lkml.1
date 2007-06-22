Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXFVTtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXFVTtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFVTsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:48:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXFVTsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:48:52 -0400
To: "Tomas Neme" <lacrymology@gmail.com>
Cc: "Andrew McKay" <amckay@iders.ca>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4679557C.5080907@iders.ca>
	<20070620175627.319a6c55@the-village.bc.nu>
	<46797C52.4020907@iders.ca> <467A99D6.6000605@iders.ca>
	<ory7idjdhn.fsf@oliva.athome.lsd.ic.unicamp.br>
	<467ADC8A.5080401@iders.ca>
	<ormyysj1yt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<2e6659dd0706220945g3592c558h2fe3d56c4b5015ff@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 22 Jun 2007 16:47:38 -0300
In-Reply-To: <2e6659dd0706220945g3592c558h2fe3d56c4b5015ff@mail.gmail.com> (Tomas Neme's message of "Fri\, 22 Jun 2007 13\:45\:11 -0300")
Message-ID: <orps3nbwkl.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22, 2007, "Tomas Neme" <lacrymology@gmail.com> wrote:

> The thing is, what matters in copyright and licencing matters is what
> the author of the code understands, no the licence's author, if
> ambiguous. And the kernel's rights holder is Linus.

Since he didn't get copyright assignments, each contributor is the
copyright holder of her/his own contribution.  And this means each
holder gets a say on how s/he understood GPLv2.

IANAL, but I think if Linus' intended interpretation had been
clarified all the way from the beginning, he could have grounds to
claim that everyone else had implicitly accepted that reading by
contributing to the project.

But since it was a decision made many years later, his clarification
on his reading of the license is in a way an additional permission
that affects only his own contributions; other authors are still
entitled to try to enforce their understanding of the legal terms of
the license, and they would have the spirit of the GPL and its
preamble on their side to guide the interpretation.  Even if contract
law states something like, in adhesion contracts, the party who writes
the contract gives the other party the benefits of any ambiguity in
the writing, the GPL is not a contract, it's a license, and per
copyright law, licenses are to be interpreted restrictively.

> Linus has the last word on it.

In the sense that he can decide to remove all contributions from
dissenting authors, yes, he does.  But he can't impose his more lax
interpretation upon other authors.  Under copyright, it's the more
restrictive reading that prevails, in that any holder who understands
his rights are being trampled can enforce them.  And since at least
one such author is vocal in his dissent, not even estoppel defenses
would apply.  But IANAL.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
