Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXDIAMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXDIAMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 20:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXDIAMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 20:12:15 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:32188 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXDIAMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 20:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nCk5lrHdq1/9AafDVPTJ3ATfp0gD5zr9NSh6sgrbxgiw6gwRZvCiVjaMThGtMGz3jAO+NIsSG9Kprvk4Aq6ZWR6tB5YTQs/+sCEK6wRAofUHYou4DkbcKchQOymg/FrtLopUEHPCAjJOZGY3o5N+LFD2OmORIjGZ4yK10zsRlww=
Message-ID: <75b66ecd0704081712w4f5758c3j5148f91115de3db9@mail.gmail.com>
Date: Sun, 8 Apr 2007 20:12:13 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: JanuGerman <doublemalam@yahoo.co.uk>
Subject: Re: Security computation within Linux kernel
Cc: linuxkernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070408143653.97346.qmail@web86905.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070408143653.97346.qmail@web86905.mail.ukl.yahoo.com>
X-Google-Sender-Auth: b97b3659357c8836
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/07, JanuGerman <doublemalam@yahoo.co.uk> wrote:
> Hi every one,
>
> I have one question regarding security libraries, already shipped with Linux Kernel. That is, all PKI, RSA libraries, as provided by OpenSSL are already integrated within the linux kernel source code? OR, one have to use OpenSSL seperately in this regard.
>
> I can see, linux/crypto.h and linux/hash.h files shipped with 2.6 kernel and know that SHA1 "hashing" can be done using linux/hash.h, but beside that, any possiblity for RSA or PKI.

What do you expect the kernel to use PKI for?  That's userspace stuff.

What problem are you trying to solve?

Lee
