Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXFLCU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXFLCU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXFLCUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:20:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:34410 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbXFLCUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BhlzwfNrxpLnifuAdzNBNW74pkrrI9nWJECdhgOZwPk2ffxwEmMk3wUF9huNNGEx1c07Sjwc1JwW+Iyr20oB8lST3+7OtpA/v3PD2ABsJaMdlsVm9JDo2Yk4TJP2LMny0C/bgyX56k9OdWTRaGjtpiKgcz3W8R4IbRCusyig8hY=
Message-ID: <3bd6b93c0706111920p36d866a6m18915696fd386473@mail.gmail.com>
Date: Mon, 11 Jun 2007 22:20:19 -0400
From: "Bruce Ashfield" <bruce.ashfield@windriver.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Can we get rid of zImage this time?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <466DE04C.4020303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466DE04C.4020303@zytor.com>
X-Google-Sender-Auth: 516b177213f05a55
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, H. Peter Anvin <hpa@zytor.com> wrote:
> I brought this up a few years ago, and had it shot down, because of a
> few poorly substantiated claims of zImage-only machines; those claims
> really need to be debugged since they might indicate A20-related failures.

These beasts are still alive and kicking. I boot a handful of
arm and ppc boards on a frequent basis that are zImage
only.  The kicker is I don't have the bootloader source for
most of them, so changing to a different image format is
tough at best.

Not a vote one way or the other, just some observations
from my day to day.

Bruce


>
> Anyway...
>
> Can we please kill zImage?  In addition to be completely useless for
> modern kernels, it causes unnecessary complexity in boot loaders.
>
>         -hpa
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
"Thou shalt not follow the NULL pointer, for chaos and madness await
thee at its end"
