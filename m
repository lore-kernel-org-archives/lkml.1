Return-Path: <linux-kernel-owner+w=401wt.eu-S933437AbXFRWhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbXFRWhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932432AbXFRWg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:36:57 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:44661 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbXFRWg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=e4X+cLZsbiJ5pCkqd923+Zi60VQuAkmlWq8zc6rtDV6tPh94rSsI99yUpdeGpb1tDR7TV5gCSbYkBvr+sbJEYRkObpqjkDpfaB57Ix45DLifOF1VCjMI5Ccn4oloHx6SMm5K7PNLdik3yvJRdci/nBmOXIzK/DUa4Ge96Tl6JCY=
To: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Mon, 18 Jun 2007 18:36:53 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181836.53736.yurimxpxman@gmail.com>
From: Joshua David Williams <yurimxpxman.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  Everybody else just cares about the legal reasons.

> The "legal terms" is the only reason a license *exists*. That's what a
> license *is*, for crying out loud!

>  If you don't care about the legal side, go and read the free software
> manifesto. That's the paper you're really arguing about.

> If you want to argue about the GPLv2 *license*, then you'd better start
> caring about the legal issues. Because that is what the license is: a
> _legal_ document.

IMHO, free and open source software seem to differ on one key point:

The Open Source Definition wrote:

> 9. License Must Not Restrict Other Software
> 
> The license must not place restrictions on other software that
> is distributed along with the licensed software. For example,
> the license must not insist that all other programs distributed
> on the same medium must be open-source software.
> 
> Rationale: Distributors of open-source software have the right
> to make their own choices about their own software.

> Yes, the GPL is conformant with this requirement. Software linked
> with GPLed libraries only inherits the GPL if it forms a single work,
> not any software with which they are merely distributed.

The way I understand it, programs licensed under the GPLv3 are *not* open 
source software. FSF is so caught up in their own agenda that they're 
forgetting the whole point - the freedom of choice. The GPLv2 may 
be "conformant with this requirement", but it goes against the ethics of the 
FSF, so we can't expect each new version of the GPL to comply to this right.

Attacking this so-called "tivozation", IMO, finally draws a distinct line 
between "free" and "open source". We, as open source developers, are not 
politicians or philosophers; we write software, and we wish to publish our 
code under a certain set of ten rights.

Yes, the GPL is a legal document, but it was written in order to compliment 
the GNU Manifesto by setting legal parameters for which they could publish 
their code under.

Until now, the GPL (v2) has had the same *legal* paramaters the open source 
developers need in order to do the job we need it to do. We have clearly went 
our separate ways now, so I think it's time to drop the GPL. (See my other 
thread about writing an open source license.)

Anyways, that's my $0.02.

-- 
It's a commonly known fact that most intruders come in through Windows.
