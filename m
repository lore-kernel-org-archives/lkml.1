Return-Path: <linux-kernel-owner+w=401wt.eu-S1762549AbYFFCzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762549AbYFFCzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYFFCzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:55:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:63301 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYFFCzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z2TY4sqKEfwbRw3A2JayDWYz6ACRHtdKNYxr0BtWpdqPYwLe6ytx5th3fTSpc2u0Qp
         k0nH+W7801hx7nTpcJsb0RplzxrAYS1U/0tsnNwCoxjwltN0ztqGtoHgwZ3vP78s5/Ec
         EMCdrV0xoZ3t5YncFXzDkfQeWEas6IOnUQaKA=
Message-ID: <aec7e5c30806051955q5f812e41y9c2f322d98333232@mail.gmail.com>
Date: Fri, 6 Jun 2008 11:55:30 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, akpm@linux-foundation.org, lethal@linux-sh.org,
       tglx@linutronix.de
In-Reply-To: <20080605064945.GA32554@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
	 <20080604101144.GA3207@local>
	 <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
	 <20080605064945.GA32554@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, Jun 5, 2008 at 3:49 PM, Uwe Kleine-König
<Uwe.Kleine-Koenig@digi.com> wrote:
> Hello Magnus,
>
> Magnus Damm wrote:
>> ... "Unique IRQ Mode". ...
> BTW, I wouldn't call it "Unique IRQ Mode" because the non-shared irq is
> only a result from automatically disabling the irq.  IMHO something like
> "No IRQ Handler Mode" is more suitable.

That may be a good idea. Any name is fine with me.

Hopefully a better name will make people less confused. =)

Thanks!

/ magnus
