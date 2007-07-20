Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXGTNg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXGTNg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXGTNgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:36:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:52468 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbXGTNgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rUlA9WgYrStMOaJGC+hZgCZ/mDUrQ7okRxE9fNt3hM8tPqcjo4/VeCJSMxUszpiOJhIhTBG1hj7yjoR0fUrOMMi4By8EgE114nP26Y6l0OS5pkFn1juv2/kjRJWQD8wenqih+RM2hQ8wAYEdHm5MmS6o5A8jgSVJLVlUZ45Z7fc=
Message-ID: <a781481a0707200636s353c8a64l5564d5f81cc7f266@mail.gmail.com>
Date: Fri, 20 Jul 2007 19:06:48 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "David CHANIAL" <david.ml@euro-web.fr>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
Cc: "Neil Brown" <neilb@suse.de>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>
In-Reply-To: <200707201533.14517.david.ml@euro-web.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200707160638.15750.david.ml@euro-web.fr>
	 <18080.22813.143226.671265@notabene.brown>
	 <a781481a0707200013g5c2ce008ka63e18f775664984@mail.gmail.com>
	 <200707201533.14517.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, David CHANIAL <david.ml@euro-web.fr> wrote:
> Le vendredi 20 juillet 2007 09:13, Satyam Sharma a écrit:
> > David, please try this and let us know if it solves your problems.
>
> How to ?
> Should i have to patch kernel tree myself ? on 2.6.22.1 ?

Yes, you can apply the patch Neil just sent to your kernel,
re-build, and test that.

Thanks.
