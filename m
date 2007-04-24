Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbXDXIPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbXDXIPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbXDXIPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:15:44 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58089 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbXDXIPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:15:41 -0400
Message-ID: <462DBC64.9070102@bx.jp.nec.com>
Date: Tue, 24 Apr 2007 17:14:28 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mpm@selenic.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 2/6] support multiple logging
References: <462605DC.2080804@bx.jp.nec.com>	<462609D1.50300@bx.jp.nec.com>	<20070419210813.a599c54f.akpm@linux-foundation.org>	<46288D11.4000801@bx.jp.nec.com> <20070420111526.01ad7f4c.akpm@linux-foundation.org>
In-Reply-To: <20070420111526.01ad7f4c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 20 Apr 2007 18:51:13 +0900
> Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> 
>>> I started to do some cleanups and fixups here, but abandoned it when it was
>>> all getting a bit large.
>>>
>>> Here are some fixes against this patch:
>> I'm going to fix my patches by following your reviews and send new patches 
>> on the LKML and the netdev ML in a few days.
>>
> 
> Well..  before you can finish this work we need to decide upon what the
> interface to userspace will be.
> 
> - The miscdev isn't appropriate
> 

Why isn't miscdev appropriate? 
We just shouldn't use miscdev for networking conventionally?

-- 
Keiichi KII
NEC Corporation OSS Promotion Center
E-mail: k-keiichi@bx.jp.nec.com





