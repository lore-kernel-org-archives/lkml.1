Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXH3LoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXH3LoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 07:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXH3LoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 07:44:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:29769 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXH3LoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 07:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L/WoPafC+VGL/n4SS596+s7ZwTH/B19Wo1YWZ6xSyu0JIgJ/LKjSn0wSaIZwal/8pUfCwqDcrGbhs+qd4NLpz3i8e8oRHNndRVeI/E8bUqT+9O0iIBDg54lt4E70xkl9SsNq0iiuHDNCJt71yjE4HXK7BMQ4AIp5uvJwtY2VqQw=
Message-ID: <ab40e9c0708300444h248a6584v49e250e4545da45a@mail.gmail.com>
Date: Thu, 30 Aug 2007 13:44:04 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: from which address does the kernel load initrd?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46D5DF7F.9030805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708291348u3c4ee095r20cd20dd090c23aa@mail.gmail.com>
	 <46D5DF7F.9030805@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi peter,

thanks for your reply.

my platform is realview_eb_mpcore. the cpu is arm. not i386. and I
check the booting file in the documentation /arm , it is not
specified.

do you have any idea about that?

anyone knows?

thanks,

regards,


2007/8/29, H. Peter Anvin <hpa@zytor.com>:
> Xu Yang wrote:
> > does anyone know from which address does the kernel load the initrd? I
> > mean the default value?
> >
> > I want to boot the filesystem using a ramdisk. but the I don't know
> > where to put it in my ram? as I don't have flash , I can only load the
> > ramdisk into the ram.
> >
> > and which boot option should I use?
>
> See Documentation/i386/boot.txt
>
>        -hpa
>
>
