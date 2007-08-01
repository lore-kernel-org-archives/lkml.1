Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbXHAGRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbXHAGRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXHAGRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:17:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:4540 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbXHAGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=aagw45LVDAe9twNyFZ6wvPgn8o0Vu5ElPJSGx3uZBhFal2NOtqxm1Kql8NLxR5YxQPGfA/AFAPYWbD0Gxrd/TwnPgfK6AW0Wy0LpJJEq3u0EhJgRw82vlv2FCTOcWlGc0durPtGYgsgrgZnQkiI9nGejwpE6R3DalRZxgSaY+rU=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Carlo Florendo'" <subscribermail@gmail.com>,
       "'Roman Zippel'" <zippel@linux-m68k.org>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'jos poortvliet'" <jos@mijnkamer.nl>, <ck@vds.kolivas.org>,
       "'Michael Chang'" <thenewme91@gmail.com>,
       "'Kasper Sandberg'" <lkml@metanurb.dk>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707282003.45142.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org> <200707282128.39906.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org> <Pine.LNX.4.64.0708010539230.1818@scrub.home> <46B01E3F.6050401@gmail.com>
In-Reply-To: <46B01E3F.6050401@gmail.com>
Subject: RE: [ck] Re: Linus 2.6.23-rc1
Date: Tue, 31 Jul 2007 23:16:50 -0700
Message-ID: <005001c7d403$8d7601a0$a86204e0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfT/2131jCTJG1aSq6t1nL9aLjJ2QAAh+Bw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Did Ingo have the obligation to improve Con's work? Definitely not.
> Did Con have a right to get Ingo's improvements or
> suggestions? Definitely not.

Yes, and that's where the inequality is.

Unless the maintainer does a really bad job or pisses off Linus,
anyone who wants to merge his code into mainline pretty much
has to get the blessing of the maintainer. On the other hand,
as you just said, the maintainer has no such obligation.

> There are no such rights in this open source
> development framework (TM).
> 
> What Ingo did, I think, was what he wanted and he has the right to do
> that.

I think it's the maintainer's privilege, not right.

> in the open source world, that which is superior (i.e. code, function, 
> not person) has the right to exist and the inferior to die away.  

I don't think it's the code superiority that decided the fate of the two
schedulers. When CFS came out, the fate of SD was pretty much already
decided. The fact is that Linus trusts Ingo, and as such he wants to merge
Ingo's code. Of course I cannot say it's wrong, and Ingo's earned this
it through years of hard work, but let's not kid ourselves and deny the
obvious fact.

I think Con was simply too frustrated after years of rejection. He could
have been more diplomatic this time round. But no matter how he'd have
done, once Ingo decided to write a new scheduler, the outcome was pretty
much already decided.

SD (and years of Con's work) inspired CFS. This is a fact. No matter how
smart and capable Ingo is, he needs inspiration to keep the good work going.
So I wish Ingo could work more closely with others and let them share a bit
more credit which would just produce even better work.

Hua


