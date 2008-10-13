Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYJML1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYJML1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbYJML1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:27:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:36319 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbYJML1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xr2eqcTbUGnGiGdAcwtrYKU8SKXEK8wDJXXgLoVuJZKdf1g+0h9LBs56NXvid/HXN+
         +nZsIoK3EjPrBl7ynpZai+i5EPJQ6csE4CKLw6PXX23qjHIRsYeXGSI2m9rNOBo/XzbS
         CfQ6YMiv4QwURsFAP7L9/bPT9lasTNHtd7jdY=
Date: Mon, 13 Oct 2008 12:27:01 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: Linux 2.6.27 will be a longtime supported kernel
Message-ID: <20081013112701.GA12706@hack.voiplan.pt>
References: <alpine.LFD.2.00.0810091651220.3210@nehalem.linux-foundation.org> <20081011210340.GA11198@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011210340.GA11198@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 12:03:40AM +0300, Adrian Bunk wrote:
>2.6.16 has become a bit dated, and I'll maintain 2.6.27 for a few years 
>as a replacement.
>
>As with 2.6.16, I'll pickup maintainance when the normal -stable 
>maintainance ends (at some point after 2.6.28 gets released in January).
>
>It is intended to fill the niche for users who are not using 
>distribution kernels but want to use a regression-free kernel for a 
>longer time. It might be a small part of the userbase, but after the 
>experiences with 2.6.16 I can say that there are quite a few users
>who appreciate such an offering.
>
>As people might have noted I wasn't able to do much kernel stuff 
>recently, and 2.6.16 also suffered from this. I'll bring 2.6.16 back 
>into shape and keep it maintained until at least mid-2009.

Thanks for your work.

I am just wondering why you only selected .16 and .27, not others?
Are there some specical reasons why you did this?

Thank you.


-- 
"Sometimes the only way to stay sane is to go a little crazy."

