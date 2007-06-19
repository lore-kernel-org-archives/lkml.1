Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbXFSKEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbXFSKEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXFSKD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:03:58 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50900 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbXFSKD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:03:57 -0400
Message-ID: <4677A9ED.80208@bx.jp.nec.com>
Date: Tue, 19 Jun 2007 19:03:25 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take5 3/7] add interface for netconsole using
 sysfs
References: <466FC455.5060001@bx.jp.nec.com> <466FC6BB.4040105@bx.jp.nec.com> <a781481a0706130849u2373983eyeab365a8bc90a4dd@mail.gmail.com>
In-Reply-To: <a781481a0706130849u2373983eyeab365a8bc90a4dd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Satyam,

First, I'm sorry I couldn't reply to your comments.
I'm so appreciate for your comments.

I will fix my patches following your advices.
But, I have some questions on the another patches. So, I want to ask you
some questions and answer your questions.

>> +static int miscdev_configured;
> 
> Is this really required? We just return with error if misc_register()
> fails during module init time itself, so it's not really useful ever, is 
> it?

You're right. It isn't required.

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com






