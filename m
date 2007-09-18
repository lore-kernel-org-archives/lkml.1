Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbXIRSPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbXIRSPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbXIRSPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:15:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:47592 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbXIRSPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kdvmt0/SqnzWL1F+/ACs3W2bMcWzlTJyvHUhrrZYLnsKDdNIudtjdJSiWLtFidxASs9GGUwl/U1wAEvErDxBSv7VLfAX0Cfn5nRpoPyH+sRLc1EOy/vVgsSiwAYeLajk2zdnwiNhi6MWLMDHq5cJAPCNU/QwEzKl1eZrna3fLFo=
Message-ID: <c5b2c05b0709181115t2e8e39fdo76954cf85f0e3cff@mail.gmail.com>
Date: Tue, 18 Sep 2007 20:15:33 +0200
From: "Primiano Tucci" <p.tucci@gmail.com>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Linux Network Load Balancing is out!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709181041250.16667@filesrv1.baby-dragons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c5b2c05b0709170929i7674a8fcl64ab60cd5f0e727b@mail.gmail.com>
	 <Pine.LNX.4.64.0709181041250.16667@filesrv1.baby-dragons.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Mr. James W. Laferriere <babydr@baby-dragons.com> wrote:
>        Hello Primiano ,
>
> On Mon, 17 Sep 2007, Primiano Tucci wrote:
> > Hi all!
> > I've just released my first beta of Linux Network Load Balancing....
> > it's a driver (+ userland tool) to make decentered load balancing
> > clusters.
> >
> > I hope someone is interested in the project and could do some testing
> > in decent environments (I've just done some "laboratory" test in a 3
> > virtualized node cluster environment, but nothing more than this).
> >
> > Sources and some documentation on http://lnlb.sourceforge.net/
> >
> > Greetings,
> > Primiano Tucci
>        Question 1 ,  Is this driver module only ?  Say I like all my drivers
> contained in the linux boot image .

Actually it's only available as a module... i think that with some
little modifications it could be transformed into a patch to build
into the kernel. I've not too much time in these days (i'm graduating
on 10th October, LNLB will be my graduation thesis ;-) )... i'll try
to search about and see if it's a short work to do. If not I'll delay
the patch after my graduation,

>        Question 2 ,  Where can I find a mailing list to subscribe to in order
> to discuss ,  problems ,  success stories , ... ?

Good point,
I edited the site and added a link to the project's forum page on
sourceforge (I think it's the best and quickest way to do it)

>        From the docs it appears to be almost a brease to setup .  I'd greatly
> like to see the driver be built into the kernel .
>
>                Tia ,  JimL

Really thanks for your interest
Primiano Tucci
> +-----------------------------------------------------------------+
> | James   W.   Laferriere | System   Techniques | Give me VMS     |
> | Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
> | babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
> +-----------------------------------------------------------------+
>
