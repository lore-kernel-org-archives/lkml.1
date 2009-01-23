Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbZAWNcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbZAWNcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZAWNcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:32:24 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:51425 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbZAWNcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:32:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BoFAhw0dh4XOHGPR6oB0FNxm1Nj+H08U1BP3YSr4Z1BpurL78DSEr/r9piZ61SjcvB
         r7hu1lCls125loWM3jAWRGS5p3S/iCQiTbp/LWoHgpRaNcj34Fp04AZ40hzAs+/nCDQU
         n35KnbasVJix8YTKcqzieBXz7nTYCYcOUDKZQ=
MIME-Version: 1.0
In-Reply-To: <1232716030.8750.11.camel@marge.simson.net>
References: <1232716030.8750.11.camel@marge.simson.net>
Date: Fri, 23 Jan 2009 19:32:21 +0600
Message-ID: <b9df5fa10901230532v57acec78qe949c44c4be2fbd9@mail.gmail.com>
Subject: Re: [patch] ratelimit performance counter interrupts
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/09, Mike Galbraith <efault@gmx.de> wrote:

>  + * Mamimum interrupt frequency of 100KHz per CPU
>  + */

Hi Mike, I think you misspelled the word Maximum here.

Thanks,
Rakib
