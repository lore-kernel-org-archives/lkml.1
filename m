Return-Path: <linux-kernel-owner+w=401wt.eu-S1030344AbXCVKEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344AbXCVKEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030339AbXCVKEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:04:00 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39562 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030332AbXCVKD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:03:59 -0400
Message-ID: <4602547A.5000600@bx.jp.nec.com>
Date: Thu, 22 Mar 2007 19:03:38 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take3 2/6][resend] support multiple logging
References: <45FFCF31.3040000@bx.jp.nec.com> <45FFD2E5.9070208@bx.jp.nec.com> <b6fcc0a0703200534w179a664dk6bfc6108879bde94@mail.gmail.com>
In-Reply-To: <b6fcc0a0703200534w179a664dk6bfc6108879bde94@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On 3/20/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
>> This patch contains the following changes for supporting multiple logging
>>  agents.
> 
>> +#define CONFIG_SEPARATOR ";"
> 
> CONFIG_* is reserved for configuration options. Since you use
> it in only one place just use semicolon directly.

Thank you for your reply.
I'm going to fix this when I send patches next time.


