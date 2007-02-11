Return-Path: <linux-kernel-owner+w=401wt.eu-S1750738AbXBKRKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750738AbXBKRKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbXBKRKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:10:16 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:59852 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbXBKRKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:10:15 -0500
Message-ID: <45CF4DE9.8080904@qumranet.com>
Date: Sun, 11 Feb 2007 19:10:01 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: KVM oops: killing interrupt handler
References: <45CE20E5.8000107@gmail.com> <45CEDB95.2020705@qumranet.com> <4af2d03a0702110601g36b4780fuec82be8290d6a397@mail.gmail.com> <45CF3BF0.2070103@qumranet.com> <45CF4B23.5050401@gmail.com>
In-Reply-To: <45CF4B23.5050401@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2007 17:10:08.0830 (UTC) FILETIME=[7B8EBDE0:01C74DFF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Avi Kivity napsal(a):
>> kvm suspend/resume support is only present in -mm (what's more, I 
>> don't think in any released -mm).  A workaround is to rmmod kvm_intel 
>> before suspending.
>
> BTW. will kvm-13's external module work?
>

Try and report back :)



-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

