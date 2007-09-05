Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbXIEQCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbXIEQCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbXIEQCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:02:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:47009 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbXIEQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oXY8loaPZb8mu3430h1zsGQ18Yda4dQTODfBImI+tXiTgVSwiG0wgivx04fBspDK0qt2cxB3kU9rRSabF882vEC7XlcV4bJ+Cu9wCbuEvFGTDZqPEgGd8QRPOOHq6d1sz/qDOXYRDxs+8WY8kHUHH/PIeSN33VKOZWW7lq4pF3k=
Message-ID: <6bffcb0e0709050902q5379bd40pe5370a9dd73c88e4@mail.gmail.com>
Date: Wed, 5 Sep 2007 18:02:03 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: nfs4 hang regression
Cc: "Bret Towe" <magnade@gmail.com>, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com
In-Reply-To: <6bffcb0e0709050856i5531bb87l1235b402e51d0556@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708221541x4fabd27er64e6ecaa33ddccbf@mail.gmail.com>
	 <20070905085120.bc90ffe2.akpm@linux-foundation.org>
	 <6bffcb0e0709050856i5531bb87l1235b402e51d0556@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi Andrew,
>
> On 05/09/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 22 Aug 2007 15:41:18 -0700 "Bret Towe" <magnade@gmail.com> wrote:
> >
> > More than two weeks, you've bisected it and there's no sign of any action?
> >
> > I don't see this on Michal's list so perhaps it already got fixed in a different
> > thread.  Have you tested current mainline?
>
> AFAIK it is fixed - commit 3d39c691ff486142dd9aaeac12f553f4476b7a62

commit 560aef74503e928f44ddbf481b8b02d9cef37dbf

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
