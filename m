Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbXFATiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbXFATiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762641AbXFAThz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:37:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:5829 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762517AbXFAThy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ciwr3eGR0Bm33EExybpkNAVHQGEuFgYKT0eR9dY1wKl+z9yINopKeXRMX62qksxD0+YOIP2ZmOQAjLGLJRkYsDU0Zf2NXP34Ozsk5ir0u9cIubH+m7vhUiGZavWJMK20HKvYdgUiITsiGH9Np0a63bxAnp7ebtVA6NTY4zQznpM=
Message-ID: <7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com>
Date: Fri, 1 Jun 2007 14:37:54 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [patch 1/1] document Acked-by:
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <m3sl9b5vcm.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	 <28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com>
	 <alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com>
	 <m3sl9b5vcm.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:
>
> > Indeed. Acked-by: implies authority, and only very few people should be
> > able to do it. Namely, the only person who can ACK a patch is a person who
> > could also NACK a patch and expect it to actually be dropped. If I think a
> > patch is bad, I can say so, but as I have no authority, my statement would
> > be taken on merit alone, whereas Linus or Andrew or such could just NACK
> > it and move on without having to spew a blurb every time.
>
> Everyone always has some authority so everyone can ack or nack any
> patch and I hope the action taken will always depend on merit
> rather than person, especially if it's a technical issue and not
> some style etc. thing.
> --
> Krzysztof Halasa
---

This is a question worth answering - is it rude to ack/nak a patch if
you're not a maintainer or otherwise known-to-be-trusted, or is it OK
for anyone to express an opinion? Andrew's patch text seems to imply
that it's generally OK.

scott
