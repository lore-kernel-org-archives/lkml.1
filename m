Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbXFVQp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbXFVQp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXFVQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:45:16 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:51286 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXFVQpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BUlxCzWcE3LFlfWV3ojp7NHNq8dj/uNLciikd5EqithsgCPDZHoiudgCGVpyI5seXYet2lkn+8fDZEBnavw1u21gzc/WwzThS1z1eNGRuyJLnNg4L5xBOYcUrIc9MG2qYXtNpevJnujloCpMFkCSj1aUbsd4eK/1AkWwi4xUEug=
Message-ID: <2e6659dd0706220945g3592c558h2fe3d56c4b5015ff@mail.gmail.com>
Date: Fri, 22 Jun 2007 13:45:11 -0300
From: "Tomas Neme" <lacrymology@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Andrew McKay" <amckay@iders.ca>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <ormyysj1yt.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <4679557C.5080907@iders.ca>
	 <20070620175627.319a6c55@the-village.bc.nu>
	 <46797C52.4020907@iders.ca> <467A99D6.6000605@iders.ca>
	 <ory7idjdhn.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <467ADC8A.5080401@iders.ca>
	 <ormyysj1yt.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> powerful.  It is pretty obvious that when Linus adopted GPLv2 he
> didn't realize it reached that point.  That when Tivo invented
> Tivoization, he decided he wanted to permit this, and thus grants an
> implicit additional permission for anyone to do it with his code,
> doesn't mean other participants in the Linux community feel the same
> way, or read the GPLv2 the same way, and could be somehow stopped from
> enforcing the license the way they meant it.

The thing is, what matters in copyright and licencing matters is what
the author of the code understands, no the licence's author, if
ambiguous. And the kernel's rights holder is Linus. The authors of the
particular bits of code can complain about what tivo's doing, but
since TiVo's using the linux kernel, and GPLv2 says

"These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it."

Linus has the last word on it. IANAL, but as far as I can tell this
reads as "this licence applies to the whole, not to the parts by
themselves", and so does who the "holder" is, I'd believe.

So if you own a part of the kernel, then you can pursuit TiVo on your
own, if they did direct use of that part especifically and break (in
your opinion) what you feel GPLv2 means. You can form the CATV2
(CodersAgainstTiVo v2) and try to get TiVo to stop using the Linux
Kernel for their product (because, believe me, they WON'T release the
keys). Yeay, we lost Tivo's improvements on the kernel, and the
posibility of having a working kernel if anyone feels like
back-ingeneering TiVo for their own amusement.

T

-- 
|_|0|_|
|_|_|0|
|0|0|0|
