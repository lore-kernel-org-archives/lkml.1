Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXJYTdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXJYTdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXJYTcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:32:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:5356 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXJYTcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=R9jSDSIPVo4/QxyAF3t/IL0KTlCFWVni9Xx98cZ17T2hX9h0Uw+Kv55UOV3FzzDBnq2Kr9hw0eBeMYsi6kISkKbDEG8HaFX5Bh3AhlhpUxl9ItK8svLjSf4m386wsiDIEeA5ItkTq0W1/ktSylu2zHZM0x4mt4ypJCKLimvoDuk=
Message-ID: <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com>
Date: Thu, 25 Oct 2007 20:32:51 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Possibility of adding -march=native to x86
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071025191723.GQ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
	 <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
	 <20071025185022.GP30533@stusta.de>
	 <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
	 <20071025191723.GQ30533@stusta.de>
X-Google-Sender-Auth: 368d0ff511124706
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/2007, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, Oct 25, 2007 at 08:09:56PM +0100, Michael Lothian wrote:
> > Actually I changed the Makefile.cpu and changed the -march to native
> > which did slightly change the size of the kernel (slightly larger I
> > think)
> >
> > So what else does that option change?
>
> Look at arch/i386/Kconfig.cpu
>

Can you be a bit more specific?
