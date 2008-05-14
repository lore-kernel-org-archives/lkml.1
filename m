Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbYENBBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbYENBBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbYENBBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:01:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:34166 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbYENBBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sPup8vBRU3gVWrq1F3JkuzYVZakPbd40Nqh0AqeaBlrpc8FpQAhX7KcnKKoouCedQEBNQrdSmW90c4lxiUKJ5i8N1XGD0DB82lFd6tOnRiY8vZesD3deoMFMYEmExJXLIPUS9z2bJ0cqyNCJm7RmQFuw3s2WzYe919oNVL4XqRw=
Message-ID: <6934efce0805131801s633a1692ha8914a76173c2c80@mail.gmail.com>
Date: Tue, 13 May 2008 18:01:33 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Bob Zhang" <zhanglinbao@gmail.com>
Subject: Re: Does anyone run AXFS in 2.4 version of kernel ? I am trying my best to apply AXFS patches into 2.4.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <85e7c2fc0805131746k5284d66dj7cfac5f9138186e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
	 <6934efce0805120923v636d2dbjb062d33fb861f5a2@mail.gmail.com>
	 <85e7c2fc0805131746k5284d66dj7cfac5f9138186e2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks for your work . we look forward your paches for 2.4.21 or
>  2.4.18 or other 2.4.x . thanks again .
>  In the meantime , I am compiling axfs patches in 2.4.18 .My policy is
>  that I basicly don't changed the AXFS code , and only add some
>  functions existed in 2.6.x into 2.4 kernel ,if necessary , I will
>  modify it . Thus , I think such working is not rather difficult ,
>  anyway , I am
>  analysing the implement of AXFS code , if necessary , I will modify
>  some functions of axfs.
>
>   Till now , AXFS_super.c has been almost ok . Next ,I will compile
>  other axfs code and check some errors and warnning , and run the
>  kernel in the skyeye which supported smdk2410 .

You're free to mess around with that if you want, but what I'm going
to release will make that a waste of time.  It's significantly
updated.
