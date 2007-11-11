Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXKKPRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXKKPRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbXKKPRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 10:17:13 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:38730 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbXKKPRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 10:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ir5okkAEI7fOEeUNwA+8fdxp4ETT7vYfzk0UWQUoqFlj0lA1nCv8ltlz8mOoI6w7Z98wUaLRuKsKLsQjjR8gXzH5zIT02e0VuiUq2ebUxE5j64/IZaGLxsYWlvJlaDES0sxzsHOirftzKJC9RXZImu2lvU/Qz8SOJ4fxG1OtgDY=
Message-ID: <7d01f9f00711110717x3eced6b2n8497476bcb17be1b@mail.gmail.com>
Date: Sun, 11 Nov 2007 16:17:04 +0100
From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
To: "dave chung" <ponstrip@gmail.com>
Subject: Re: [PATCH] drivers/video/s1d13xxxfb.c as module with dbg
Cc: "Stanislav Brabec" <utx@penguin.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <d7b238da0711101529s3384cb6bx928c74cfef8fde0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1194709875.4486.8.camel@utx.utx.cz>
	 <d7b238da0711101529s3384cb6bx928c74cfef8fde0f@mail.gmail.com>
X-Google-Sender-Auth: cec9cf83872fdc9c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 11, 2007 12:29 AM, dave chung <ponstrip@gmail.com> wrote:

> we also need to look at splitting out the "chip revision", which is
> currently hard set, as I have had very good results with this driver
> and  chip  S1D13506, which is functionally similar but without the
> external clocking and without teh internal ram.

Well I wrote the initial driver mostly as a rather quick hack. I
didn't have access to other hw from the s1d13 family (other than the
806) at that time, and could only guess that supporting them shouldn't
be too complicated. Nowadays I don't even have access to the 806
itself anymore, so I'm afraid I won't be of much help.

HTH

T-Bone

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
