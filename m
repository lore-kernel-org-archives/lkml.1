Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbXJ1SuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbXJ1SuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXJ1SuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:50:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:15247 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXJ1SuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=LC67gYq45uncH7N7UbmTE1SwMR+gvNzpUw4I9dXguUUvKc03XUemlAKAQZXLnuaxb1+LQP/WMSlB/kATVAH7q+hWm+Fw9RNvNuztdP34gHDRaKaMUji/Ay8iOnM9CvygSje/tBetxBfR+Ii7GwzL/hjbVhWViTMGeguYiA8dS1M=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Pavel Machek'" <pavel@ucw.cz>, "'Ray Lee'" <ray-lk@madrabbit.org>
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Chris Wright'" <chrisw@sous-sol.org>,
       "'Casey Schaufler'" <casey@schaufler-ca.com>,
       "'Adrian Bunk'" <bunk@kernel.org>, "'Simon Arlott'" <simon@fire.lp0.eu>,
       <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
       "'Jan Engelhardt'" <jengelh@computergmbh.de>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Andreas Gruenbacher'" <agruen@suse.de>,
       "'Thomas Fricaccia'" <thomas_fricacci@yahoo.com>,
       "'Jeremy Fitzhardinge'" <jeremy@goop.org>,
       "'James Morris'" <jmorris@namei.org>,
       "'Crispin Cowan'" <crispin@crispincowan.com>,
       "'Giacomo Catenazzi'" <cate@debian.org>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com> <20071025002356.GB3660@sequoia.sous-sol.org> <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com> <20071025024131.6082e4a8@the-village.bc.nu> <2c0942db0710251117k37c30b2ex5cc6d8cd8c9ea029@mail.gmail.com> <20071027182911.GD4159@ucw.cz>
In-Reply-To: <20071027182911.GD4159@ucw.cz>
Subject: RE: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Date: Sun, 28 Oct 2007 11:48:47 -0700
Message-ID: <008101c81993$301f1750$905d45f0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcgZjlwFpFPt2li5SpKpcqUD1itVswABM5Kg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Pavel Machek
> Sent: Saturday, October 27, 2007 11:29 AM
> To: Ray Lee
> Cc: Alan Cox; Chris Wright; Casey Schaufler; Adrian Bunk; Simon Arlott;
> linux-kernel@vger.kernel.org; linux-security-module@vger.kernel.org;
> Jan Engelhardt; Linus Torvalds; Andreas Gruenbacher; Thomas Fricaccia;
> Jeremy Fitzhardinge; James Morris; Crispin Cowan; Giacomo Catenazzi
> Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
> static interface)
> 
> Hi!
> 
> > > > The idea that poor security is worse than no security is
> fallacious,
> > > > and not backed up by common experience.
> > >
> > > There is a ton of evidence both in computing and outside of it
> which
> > > shows that poor security can be very much worse than no security at
> all.
> >
> > (So, I take it that you *don't* lock your bike up, as poor security
> is
> > worse than none?)
> 
> I do lock my bike with combination lock I found somewhere and cracked
> in five minutes... sometimes.
> 
> But do you suggest that I use paper tape to 'lock' my bike to
> streetlight? You just said that poor security is better than none,
> right?
> 
> 							Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

