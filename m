Return-Path: <linux-kernel-owner+w=401wt.eu-S933711AbXGWXIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbXGWXIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765026AbXGWXIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:08:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:7792 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762070AbXGWXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:08:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SZWpnMY9mxnwDr26CwKps7UmRgnAjt9UTMrjLjFvXdVD/DmhLH9egxgriqikBM/K9E40ngfsZGyHOxFJOOh5MFNpml5juR3DQuMx4XmZ5D0AP/Cp287uGz9pZvI+2rMwR9pmA20/GoW0eeVT6YV+vNT3lOgHcTqVYN4zjWKFzj4=
Message-ID: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
Date: Tue, 24 Jul 2007 01:08:35 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: -mm merge plans for 2.6.23
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "ck list" <ck@vds.kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707102015.44004.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/07, Con Kolivas <kernel@kolivas.org> wrote:
> On Tuesday 10 July 2007 18:31, Andrew Morton wrote:
> > When replying, please rewrite the subject suitably and try to Cc: the
> > appropriate developer(s).
>
> ~swap prefetch
>
> Nick's only remaining issue which I could remotely identify was to make it
> cpuset aware:
> http://marc.info/?l=linux-mm&m=117875557014098&w=2
> as discussed with Paul Jackson it was cpuset aware:
> http://marc.info/?l=linux-mm&m=117895463120843&w=2
>
> I fixed all bugs I could find and improved it as much as I could last kernel
> cycle.
>
> Put me and the users out of our misery and merge it now or delete it forever
> please. And if the meaningless handwaving that I 100% expect as a response
> begins again, then that's fine. I'll take that as a no and you can dump it.
>
For what it's worth; put me down as supporting the merger of swap
prefetch. I've found it useful in the past, Con has maintained it
nicely and cleaned up everything that people have pointed out - it's
mature, does no harm - let's just get it merged.  It's too late for
2.6.23-rc1 now, but let's try and get this in by -rc2 - it's long
overdue...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
