Return-Path: <linux-kernel-owner+w=401wt.eu-S937107AbYEUUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937107AbYEUUHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYEUUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:07:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:40620 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbYEUUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nJ4tB0HFdRZU+3SrhondrBvBUOcBRfejs6fekdmnsaVC3Ps+iSMQ8wjqf+o0MIphnu83+8IfHiuj1HElAlWYjIuc0Tky0PmHV6qGNOKOkwBylA7blvNAXf3an2XiZlTLXynAiWSNx/pZVAuvnuGKsNi2xYQDSgvoe6AmppyxxKI=
Message-ID: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com>
Date: Wed, 21 May 2008 22:06:55 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard indentation of arguments)
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, rdunlap@xenotime.net,
       tytso@mit.edu, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <20080521125449.344a445d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12113495282137-git-send-email-kongjianjun@gmail.com>
	 <20080521083413.GM28946@ZenIV.linux.org.uk>
	 <20080521015037.add0b78e.akpm@linux-foundation.org>
	 <20080521103206.GA24545@infradead.org> <20080521120939.GF8581@mit.edu>
	 <20080521104644.5b6f4e63.akpm@linux-foundation.org>
	 <20080521185725.GD6932@cvg>
	 <20080521123355.b34f07ad.rdunlap@xenotime.net>
	 <20080521194522.GA13916@cvg>
	 <20080521125449.344a445d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 21 May 2008 23:45:22 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> Anrew, Randy, you just wrote KernelNewbiesGuide I think ;) There are
>> lot of internet sites which could help with what-to-do, and linux-mm.org
>> and kernel.bugzilla.org and more BUT what I've tried to say is that we
>> really have such document inside kernel tree (it could be really short)
>> like:
>>
>> Which patches are not good for sending to LKML
>> ----------------------------------------------
>>
>>  - Plain whitespace cleanup
>>
>> Some rules just *known* only if you have an experience in LKML mailing
>> but if someone is sending _first_ patch he ever made he just doesn't know
>> that. That is all. So we need not a link to some inet resource BUT written
>> in file inside of kernel tree. But that is just my (personal) opinion.
>
> Yes, a general GettingStarted document would probably be useful.
> It would hopefully have more what-to-do content than what-not-to-do.

I'm in the process of trying to write an initial draft of just such a
document right now. I'll post it once I'm a bit more done (gimme an
hour or two).

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
