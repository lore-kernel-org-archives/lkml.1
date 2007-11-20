Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbXKTMxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbXKTMxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXKTMwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:52:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:43118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXKTMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:52:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ELl3iAOSwGLhSxtf5zBW20ysd+CKAKUkUeo9G0lVYY48SbKFnj+C0hKjvGdJXOpc/qEdkC2JVaMTCHu6h/u9iThLxwn7Y9s1qu86MS3aEPFwTnTC9qr3qIWmm8k/wUDCR4FWpZqF0WNWcNJEwyXC0CFznFMqPXArZ6yeeQrYlE4=
Message-ID: <5a4c581d0711200452u1f7c9dc3h63e2697926ce1be0@mail.gmail.com>
Date: Tue, 20 Nov 2007 13:52:52 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: Is there any word about this bug in gcc ?
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David Miller" <davem@davemloft.net>,
       xiyou.wangcong@gmail.com, goodmenkernel@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071120065212.GA14702@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au>
	 <4742831F.9040408@zytor.com>
	 <20071120065212.GA14702@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20, 2007 7:52 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Nov 19, 2007 at 10:47:59PM -0800, H. Peter Anvin wrote:
> >
> > This one is definitely messy.  There is absolutely no way to know what
> > gcc has miscompiled.  It looks to me that both gcc 4.2 and 4.3 are
> > affected, any others?
>
> I just tested it here and gcc 3.3 is also affected so presumably
> everything in between is too.  Gcc 2.95 is not affected.  I don't
> have the intervening versions to test.

Fedora 7's 4.1.2-27 is also affected.

--alessandro

 "you feel the sweet breath of time
  it's whispering, its truth not mine"

   (Interpol, 'No I In Threesome')
