Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbXFGIyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbXFGIyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbXFGIx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:53:57 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:16110 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbXFGIxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZOrJF6PEIfVeP6M7kB/QDG1Kb1orPNoshD+I43nM2ImyhwlOeCGq1t0LOrxs8JtKlwIQZI+qmbCIdxrY3rUdQKHEVwmLr+3azYizsMPyuI/3T8QH88AVvT2JrUP21QSk9fRKUKtveJyv9MthtREyvkrWVVDxTYMKmTcc4QgXvLk=
Message-ID: <4cefeab80706070153p4021883aq14d3be080ba682cd@mail.gmail.com>
Date: Thu, 7 Jun 2007 14:23:54 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <rpurdie@openedhand.com>
Subject: Re: [PATCH -mm] Add LZO1X compression support to the kernel
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1181204856.6086.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181150792.5686.51.camel@localhost.localdomain>
	 <4cefeab80706062141u5fea846ane51c90dc89732db5@mail.gmail.com>
	 <1181204856.6086.13.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> On Thu, 2007-06-07 at 10:11 +0530, Nitin Gupta wrote:
> > Your code now looks nice and clean. But I don't know what you want. I
> > already spent lot of time on version 7 I posted and contains all those
> > corrections which were suggested for my earlier version. I cannot ask
> > you to look into possible problems (if any) in my code now since  you
> > are not interested in that anyway. So, please continue this
> > duplication.
>
> What I (and others) repeatedly asked for was an explanation of why there
> were the differences between the bytecode from your version and the
> bytecode from mine. This was never explained by you and I was left to do
> this myself. Sadly, doing so meant some duplication.
>

I don't know the reason for bytecode difference. I focused on making
sure that the C code is functionally identical to original code. I
never did a bytecode diff.

> Anyhow, I think I can now explain the differences. Now we have two
> versions, its a question of how to proceed. Basically one needs to be
> merged into the other. I will try and compare the two patches and see
> what differences we have.

Sounds good.

Regards,
Nitin
