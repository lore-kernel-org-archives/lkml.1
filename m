Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYHVKu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYHVKu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYHVKuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:50:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:5813 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYHVKuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q6U1tgo9KT9Ed31zKupgJCkOa+eT80VZcqwBqIirxN8a5up62HH1kH2ERY81rxVfMX
         t0YnbGViXfrV4KMv+K8JCjXX2Umxf3EG6se5VahnO+sojLVkhb72ZPlmyYjv/MVS83/7
         pDnsuqONWrC9lc6iU+uBUfm6bXwNoJi47d5lM=
Message-ID: <8db1092f0808220350wc56af7di5c5e1c2eb2421249@mail.gmail.com>
Date: Fri, 22 Aug 2008 12:50:06 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <200808221210.59560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <200808211445.46467.rjw@sisk.pl>
	 <8db1092f0808220158k742c6429y5f8ee48d5eb61a30@mail.gmail.com>
	 <200808221210.59560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/22 Rafael J. Wysocki <rjw@sisk.pl>:

>> http://unixy.pl/maciek/download/kernel/2.6.27-rc3/dmesg-2.6.27-rc3.txt
>
> This doesn't look like the same configuration as in the picture you
> sent previously.  In particular, the ICH7 lines are missing.
>
> Thanks,
> Rafael
>

I'm sorry, I boot wrong kernel. This is correct:
http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.26-rc2-initcall_debug.txt


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
