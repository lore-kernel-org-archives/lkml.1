Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXLIWvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXLIWvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXLIWv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:51:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:11846 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXLIWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GVRS/0ksKI+gsynNv/Xy270/m/cLLN9crwU+U4SddG2fr0Px/p6IjQuZNufyabCmrUjCluNcM1EW6GsE9KGw1w84VxQQFx18przvD6uuTKt3xoGD/AQu61j9D6TrJ7ItxUt4biFt9dsOVwCeWkvLX+b8M5Bp6/I58KhrD2Gicwg=
Message-ID: <2c0942db0712091451sb1bb421vd3149f23791361c7@mail.gmail.com>
Date: Sun, 9 Dec 2007 14:51:23 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Tejun Heo" <htejun@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20071209220132.53268368@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712080340.49546.rjw@sisk.pl>
	 <20071208015227.3a1c7fae.akpm@linux-foundation.org>
	 <475B9270.6070902@gmail.com>
	 <20071209134217.7ff02dd2@the-village.bc.nu>
	 <alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org>
	 <20071209220132.53268368@the-village.bc.nu>
X-Google-Sender-Auth: 3f142fd4409acc52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 9, 2007 2:01 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Btw, Alan, that "math" is total and utter BULLSH*T, and you should know
> > that.
>
> To blindly argue regressions are critical is sometimes (as in this case)
> to argue that "this freeway is no longer compatible with a horse and
> cart" means the freeway should be turned back into a dirt road.

Honest question: If you allow regressions, then how does one guarantee
forward progress? (If it were a finite set of systems, all within one
group's control, then the answer is simple: count how many work.
However, in this case we only have a statistical sampling available to
us.)

Ray
