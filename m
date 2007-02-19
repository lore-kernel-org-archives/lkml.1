Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbXBSVuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbXBSVuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932715AbXBSVuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:50:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:34198 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655AbXBSVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:50:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=saeEEPDlUGxJ8/suuGPdGSS7I54922RQ+oSbx0u0QJ7vzIKH5HKxJMQ3B3lcSVbZqJ71lSWxzzbhxXBb4IvUxkh55jIzimbedHYakXnOiV1pvuYmFV4vO7DaKJzyJagb8V4GqHmATS3fADw0T6erQsbedPIruGWuMZsAHQfzuyE=
Message-ID: <f2b55d220702191350t142fcce5r463a4c9b2d878c12@mail.gmail.com>
Date: Mon, 19 Feb 2007 13:50:05 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: Alan <alan@lxorguk.ukuu.org.uk>, "Scott Preece" <sepreece@gmail.com>,
       "Alexandre Oliva" <aoliva@redhat.com>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0702191535010.18507@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <MDEHLPKNGKAHNMBLJOLKKEIPBKAC.davids@webmaster.com>
	 <orire1s39s.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	 <7b69d1470702171129x36c4352cyc5b3a4b217729bf5@mail.gmail.com>
	 <f2b55d220702171315xb82d37cx4f98dc9d96d51b10@mail.gmail.com>
	 <20070219203149.27c3b696@localhost.localdomain>
	 <f2b55d220702191220yab592adw213e7d76db39e7e2@mail.gmail.com>
	 <Pine.LNX.4.61.0702191535010.18507@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> FWIW. A license is NOT a contract in the United States, according to
> contract law. A primary requirement of a contract is an agreement. A
> contract cannot, therefore, be forced. Licenses, on the other hand,
> can be forced upon the user of the licensed material.

Wrong.  Acceptance through conduct has been integral to contract law
in common-law countries since the days of writs in Chancery, and is
part of the codification of the difference between contracts "in
personam" and "in rem".  Allow me to recommend Kevin Teeven's "A
History of the Anglo-American Common Law of Contract".  It is settled
law throughout the Western world that non-exclusive licenses of
copyright need not be formalized, or even put in writing.  Licenses
cannot in any sense be forced on anyone; they are simply a defense
against an action for tort, a conditional waiver of the right to sue,
and cannot even be introduced as evidence by a plaintiff.

> A license is a document that states the conditions under which an
> item may be used. A prerequisite of the licensor is that he/she/they
> have a legal right to control the thing being licensed. When a licensed
> item has its license modified by a party, not the original licensor,
> it is quite possible that such attempts to control the item are
> invalid (moot). Lawyers like this because it gives them work since
> the final resolution of such a action can old be determined by a
> court!

Wrong again.  A copyright license is a term in an otherwise valid
written, oral, or implied offer of contract, with certain limitations
of scope and certain conditions and covenants of return performance,
waiving the right to sue for the statutory tort of copyright
infringement.  Read Nimmer on Copyright, or follow the links in this
paragraph (another self-quotation from two years ago,
http://lists.debian.org/debian-legal/2005/01/msg00621.html):

<old>
Same difference, legally.  Non-exclusive license has a longer history
in patent cases than in copyright, and copyright cases frequently
point to patent cases as precedent.  The commonly cited Supreme Court
precedent that a non-exclusive patent license is "a mere waiver of the
right to sue" is a 1927 case (De Forest Radio Telephone v. United
States, http://laws.findlaw.com/us/273/236.html ), which in turn cites
Robinson on Patents -- so it was evidently already well established by
then, at least with respect to patents.  Everex Systems v Cadtrak (aka
in re CFLC) 1996, for instance, cites De Forest in concluding that
such a license constitutes significant continuing performance
(settling, as far as I am concerned, the question about whether GPL
release is a "one-shot" act with no continuing performance -- it's
not).  For an example that all this applies to copyright, see Jacob
Maxwell v. Veeck 1997 ( http://laws.findlaw.com/11th/962636opa.html ),
which brings in re CFLC over to the copyright arena.
</old>

Please do not bother to trot out Webster's definition or medieval uses
of the word "license", or the theory of unilateral license with regard
to trespass and third-party beneficiaries.  These are concepts
different from "license" as used in the phrase "non-exclusive
copyright license", and just happen to be spelled the same.

Cheers,
- Michael
