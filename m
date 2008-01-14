Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYANQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYANQrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYANQrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:47:05 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:40383 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYANQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ti9pH7v6pNEEyuD950GlS+VCFAgrgfsKQrATYRSSrZlK90v2bJ3Jm5RzpKT3T8MTtUyXYMIZI4Si3Pc2toQ8YgiJ1USBQR5AU0PGwqPIDArGnXHu79Ao1YB7QIrFVKTCEEXqjRCRgUjFJsXQ9MXsctUdX0kr+SQPFQ852MoGBeQ=
Message-ID: <e85b9d30801140847k4b19cea4nd08461c1664a1b35@mail.gmail.com>
Date: Mon, 14 Jan 2008 17:47:00 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ed Tomlinson" <edt@aei.ca>
In-Reply-To: <20080114161359.GD15542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com>
	 <47841C41.4060401@zytor.com>
	 <e85b9d30801101310p485c7686o30b7cd581043712@mail.gmail.com>
	 <47868B6D.6030208@zytor.com>
	 <e85b9d30801101352hf66826eqe436e61310c96f14@mail.gmail.com>
	 <478694CB.4000306@zytor.com>
	 <e85b9d30801101428s1c760cb1i5ee415738dffb90f@mail.gmail.com>
	 <47869C93.2060308@zytor.com>
	 <e85b9d30801101453k21c60f81v1975cde6a8d5ed52@mail.gmail.com>
	 <20080114161359.GD15542@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> FYI, latest x86.git should have this fix included. So if your box still
> hangs there must be some other bug lurking as well.


the fix from Roland ?: http://lkml.org/lkml/2008/1/11/108
http://forums.gentoo.org/viewtopic-p-4719206.html#4719206 (+ following posts)

works like a charm :)
wine-problems should be solved,

64bit firefox & 32bit flash, 32bit firefox, 32bit thunderbird,
realplayer work fine again without hardlocking so far  (at least for
me)

Thanks to everyone involved

>
>         Ingo
>

Regards
Mat
