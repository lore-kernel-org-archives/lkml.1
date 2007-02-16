Return-Path: <linux-kernel-owner+w=401wt.eu-S1422766AbXBPAEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422766AbXBPAEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422770AbXBPAEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:04:21 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:36041 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422766AbXBPAEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:04:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sW1LaNnxISyInk4weer3zRXSSKPx/q839F738HbPSKUwI0ROnLSAQNe4CqCMnafFArbv8Se4/uLWcXvuGI9qK/YDaNpbdzrKJmTprAfeetf/KoJ9Hg2SM256DzqXNJH7YHXKhkYPvGFkviO0RgYe5EVp729ruWbIS5NQsh/TK14=
Message-ID: <f2b55d220702151604l1af2dad3k61758a654244ca6c@mail.gmail.com>
Date: Thu, 15 Feb 2007 16:04:18 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: GPL vs non-GPL device drivers
Cc: "v j" <vj.linux@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
       "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45D4DCE3.9070002@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <45D4DCE3.9070002@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Jeff Garzik <jeff@garzik.org> wrote:
> v j wrote:
> > So far I have heard nothing but, "if you don't contribute, screw you."
> > All this is fine. Just say so. Make it black and white. Make it
>
> It is black and white in copyright law and the GPL.
>
> The /whole point/ of the GPL is to funnel contributions back.

Bzzzt.  The whole point of the GPL is to "guarantee your freedom to
share and change free software--to make sure the software is free for
all its users."  Undo the EXPORT_SYMBOL_GPL brain damage if you like;
it's not part of the offer of contract, which ties itself in knots to
avoid any measure of derivative-ness other than that enshrined in the
appropriate jurisdiction's copyright law (conformant to the Berne
Convention anywhere that matters).  Fork to your heart's content; if
it breaks, you get to keep both pieces.  Just remember that there is
also no severability clause in the offer of contract (very much the
contrary; see Section 7), so if the contract breaks, you do not
necessarily get to keep both pieces, and weird things happen when you
wander off into the vagaries of your jurisdiction's tort law and
commercial code.

> We happen to think there are solid engineering reasons for this.
> Customers think there are solid reasons for this. Libre activists think
> there are freedom aspects to this.

There are no solid engineering reasons for demanding code that is
probably crap, tied to hardware you will never see, from people with
regard to whom you indulge in mutual hostility and distrust.  There
are, however, solid economies of scale in warranting the unwarrantable
and hand-holding at each stage of the skill hierarchy, and they depend
on keeping the interchangeable parts interchangeable.  The "IP asset"
delusion interferes with these economies of scale and annoys the
Morlocks who keep the gears turning.

99% of customers could care less; show them good, fast, and cheap,
offer them two out of three, they'll leave "good" on the table every
time.  Libre activists don't understand the meaning of the word
"freedom", at least not in the same way I do; freedom is spelled
R-U-L-E O-F L-A-W and they seem to have contempt for this concept.

> But ignoring all the justifications, it /is/ the letter of the law.  And
> you are expected to follow it, just like everybody else.

Fiddlesticks.  The letter of the law is very different from what you
have been led to believe.  Most law is created in the marketplace,
discovered in a courtroom, codified by a legislature, reconciled by
treaty and gunship, and enforced by insurers and other financial
institutions.  This kind of law considers the "free software"
philosophy to be a curiosity at best, and renders the GPL down to:

     You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work ...

     You must cause any work that you distribute or publish, that in
whole or in part contains or is derived from the Program or any part
thereof, to be licensed as a whole at no charge to all third parties
under the terms of this License.

     ... you must cause it ... to print or display an announcement
including an appropriate copyright notice and a notice that there is
no warranty (or else, saying that you provide a warranty) ...

     ... Accompany it with the complete corresponding machine-readable
source code ...

     *** BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, *** THERE IS
NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE
LAW.

That's a straightforward license of modification and distribution
rights in return for attribution and warranty disclaimer, just like
any other "open source" license; except that it creates SEVERE
obstacles to commercial exploitation without cutting the originator
in, just like most "free as in beer" licenses.  The rest of the GPL is
composed of no-ops in any legal system that matters.  Don't take my
word for it; read the actual court decisions in which the GPL has come
up, and Nimmer on Copyright for the backstory.

IANAL, YMMV, HTH, HAND, Cheers,
- Michael
