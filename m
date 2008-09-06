Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYIFSHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYIFSHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYIFSHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:07:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:55631 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752757AbYIFSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:07:38 -0400
X-Authenticated: #310364
X-Provags-ID: V01U2FsdGVkX18V3pgv5ykVQiawX5kPFiptpKfsS7+lnFmhvsTPHZ
	sfDY1KNiiMCzMn
Message-ID: <002d01c9104b$6f02b5d0$0201a8c0@zeug>
From: "Sebastian Herbszt" <herbszt@gmx.de>
To: =?UTF-8?Q?Pawe=C5=82_Sikora?= <pluto@agmk.net>,
       <linux-kernel@vger.kernel.org>
Cc: <kvm@vger.kernel.org>
References: <200809061657.41340.pluto@agmk.net>
Subject: Re: kvm-intel + vista64 installer == BSOD.
Date: Sat, 6 Sep 2008 20:05:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paweł Sikora wrote:
> Hi,

added cc: kvm@vger.kernel.org

- Sebastian

> i'm trying to install vista64 with integrated sp1 on virtual machine
> and getting bsod during installer startup -> http://imagebin.org/25860
>
> hardware: intel q9300 with 8GB of ram.
> software: kvm-74, qemu-0.9.1-13k, kernel-2.6.26
>
> in dmesg i found only few lines:
>
> [ 277.882001] SIPI to vcpu 1 vector 0x10
> [ 277.882001] SIPI to vcpu 2 vector 0x10
> [ 277.882001] SIPI to vcpu 3 vector 0x10
> [ 283.352002] apic write: bad size=1 fee00030
> [ 283.352002] Ignoring de-assert INIT to vcpu 0
> [ 283.352002] Ignoring de-assert INIT to vcpu 1
> [ 283.352002] Ignoring de-assert INIT to vcpu 2
> [ 283.352002] Ignoring de-assert INIT to vcpu 3
>
> i have no idea what's wrong :(
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

