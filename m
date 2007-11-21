Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXKUGDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXKUGDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXKUGDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:03:36 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:36399 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbXKUGDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sQHJ99m56DhIX8jKb8gUKstGX85KO6cDQ85Xe4KyFwe275WBxviKiNj46X5OSVTUG+fLcRlAKbc6tba5/8382BD8Z4E3B8y/f2Z055GWGT70UJvWycDO7W9TPBe72VydOYcYMke9/QCDZGwhmk98c1I5U5bj4tm315FlR0CF5XQ=
Message-ID: <a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com>
Date: Wed, 21 Nov 2007 14:03:34 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071120220046.db5c8fde.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>
	 <20071120220046.db5c8fde.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 21, 2007 2:00 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 21 Nov 2007 13:51:47 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
>
> > Hi, andrew
> >
> > modpost failed for me:
> >   MODPOST 360 modules
> > ERROR: "empty_zero_page" [drivers/kvm/kvm.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >
>
> You're a victim of the hasty unexporting fad.  Which architecture?
> x86_64 I guess?
>
Hi,
ia32 instead.

Regards
dave
