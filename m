Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbXCQSXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbXCQSXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 14:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXCQSXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 14:23:30 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:2792 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbXCQSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 14:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=egw/CnfMtSH0fyzMtpYfJmeQP2x95qPj1JhBKNTQzPdYQbJzW5bMjCcwvItAch9vrTc0UxQ8LZH7O8ANDMhPj5ZrWVJhCSJMM3cEqUcmSyQoaPaUb00s+P5NnkESKz0Xhnzd6+lgqEx+f44j+dWcIlM3SPODq0Z9COhVGgumdQU=
Message-ID: <367a23780703171123r142644baib0466ce6449d7c60@mail.gmail.com>
Date: Sat, 17 Mar 2007 19:23:28 +0100
From: "Kacper Wysocki" <kacperw@online.no>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [ck] Re: RSDL v0.31
Cc: "Gene Heskett" <gene.heskett@gmail.com>, "Al Boldi" <a1426z@gawab.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nicholas Miell" <nmiell@comcast.net>
In-Reply-To: <1174153022.7332.1.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170805.59619.gene.heskett@gmail.com>
	 <1174138590.7614.6.camel@Homer.simpson.net>
	 <200703171303.42795.gene.heskett@gmail.com>
	 <1174153022.7332.1.camel@Homer.simpson.net>
X-Google-Sender-Auth: ba62755e34ce5913
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/17/07, Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2007-03-17 at 13:03 -0400, Gene Heskett wrote:
> > On Saturday 17 March 2007, Mike Galbraith wrote:
> > [...]
> > >Xorg is using 50% cpu because I'm asking it to.
> >
> > What advantage is that giving you?
>
> It's a test scenario.  Read the thread please, I really don't want to
> repeat myself endlessly.

I've been following "this thread" since Con's .31 announcement - and
the only reference to your test scenario that you've given is that
you're still "having trouble with x/gforce vs two niced encoders",
that you've added "some targeted unfairness", that Con's new scheduler
is "an utter failure" and something about beating it to a bloody pulp.

You haven't detailed what your test actually is or what it's trying to
acheive, nor provided anyone else with the means to reproduce it or
understand any of the behaviour you're seeing. Now if you've done that
in any other thread, consider referencing it instead of worrying about
"repeating yourself endlessly". Otherwise, you're making it pretty
clear that you're just trying to be difficult, rather than being
heard.

Remember, this thread is not only cross-posted, but also exists in a
high-volume mailing list where things aren't as easy to track as in
one's own head.

And for Mark and others who are as confused as I was, this is the
thread that Mike meant to reference:
http://thread.gmane.org/gmane.linux.kernel/503455/focus=6614

Cheers,
 -Kacper
