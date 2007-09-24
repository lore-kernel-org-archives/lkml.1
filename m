Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXIXV1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXIXV1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXIXV13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:27:29 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:10364 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXIXV12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RcPbxrcjSe+/54e+Ehhuc8D9aubzHgbIZcdwFiCLw8nVVM3GLCmik5uWRxUWw7F/NQzuZCJHHirgwVvxiZULW2BTUsdZ1y5kHLGvxPHafpQK60i5sSDHfjE0lNjCeW6AjLMYI1Wpe43Ghtz1uWru21LmMRxVfmfeRfhHUgcT0hk=
Message-ID: <88dfed9d0709241427v329aeed9jfbc298666ac483c8@mail.gmail.com>
Date: Tue, 25 Sep 2007 05:27:27 +0800
From: hufey <hufeyy@gmail.com>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Subject: Re: realtime preemption performance difference
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/07, Jaswinder Singh <jaswinderlinux@gmail.com> wrote:
> Hi all,
>
> I want to check performance difference by using realtime preemption patch :
>
> http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Please let me know from where I can download samples to test realtime
> preemption performance difference.
>

As far as I know, some embedded linux vendors such as MontaVista
provide kernel patch to export some interfaces to measure realtime
performance.

> Can someone please share performance numbers for your hardware:-
>
> 1. Interrupt latency
> 2. Task switching time
> 3. hard-realtime scheduling latency
>
> Thank you,
>
> Jaswinder Singh.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
