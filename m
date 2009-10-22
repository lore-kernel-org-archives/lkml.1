Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZJVTtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZJVTtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZJVTtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:49:20 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:61257 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZJVTtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=LcsMvcB6AHavy61mBvCSYjRsFApnBBYNN38ptKOxo4ZT7RV3S0ueu/GEywCZxUbsAn
         TUuAkvtwarcYGGbAfUeTA4so8CUmGmd2gkwRGmsnZgzTHE2o1W9rRMqcdsQtDnTb3InS
         CofyGU3yky64hmkbrQtpiyc7kCKBaOUZJH1ic=
MIME-Version: 1.0
In-Reply-To: <20091022193532.GC6611@elf.ucw.cz>
References: <20091006200339.GA1538@ucw.cz> <20091017163627.GB1423@ucw.cz> 
	<f17812d70910200859v6d18e81bs2760d8af1d8da5bf@mail.gmail.com> 
	<f17812d70910220705o9f4a0ddwa22157b59a519350@mail.gmail.com> 
	<20091022174816.GC5325@elf.ucw.cz> <f17812d70910221126k50c4ea7em9d58f6e85db884ae@mail.gmail.com> 
	<20091022191954.GB6611@elf.ucw.cz> <f17812d70910221228y6613ff5eg813129b37ccfe0a1@mail.gmail.com> 
	<20091022193532.GC6611@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 23 Oct 2009 03:49:04 +0800
Message-ID: <f17812d70910221249p98d9cc3n30b27cd9a86254b0@mail.gmail.com>
Subject: Re: zaurus: cleanup sharpsl_pm.c
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 3:35 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > Well, I'd say that the sharing leads to some very ugly code. ... so
>> > I'd preer it unshared.
>> >
>>
>> I suggest to re-name it to "sharpsl_" something instead of "spitz_",
>> to be less confusing at this moment.
>
> Yep, but lets do that as next patch, ok?
>
>> > But if you would prefer, I can prepare patch without the table
>> > moving...?
>>
>> That would be appreciated.
>
> Here it is.

Applied.
