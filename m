Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbZEGJDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbZEGJDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZEGJDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:03:35 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:56721 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZEGJDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nWBys7liLuQN/zGup7ANukLkFT4BOTTrY9RGTRMh8xnCSfWXzgq+HoPpVP0TYEXA57
         274OulA3gCkqc6HSl0Z5fcIwWNmxGTufvJs60El09U5n6tSs3AN8I/6K1wE3VlEfO2TA
         OdEaMVI1Uq4xqUc0ueIgI+ygUl2AP+OSJzTV0=
Message-ID: <4A02A3E1.90706@gmail.com>
Date: Thu, 07 May 2009 11:03:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Yang Hongyang <yanghy@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] remove DMA_nBIT_MASK macro
References: <20090507141114M.fujita.tomonori@lab.ntt.co.jp> <20090506223452.65e545d8.akpm@linux-foundation.org> <4A029BE1.4090309@cn.fujitsu.com> <4A029FD1.1050007@gmail.com> <4A02A2D8.4090209@cn.fujitsu.com>
In-Reply-To: <4A02A2D8.4090209@cn.fujitsu.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2009 10:59 AM, Yang Hongyang wrote:
> Jiri Slaby wrote:
>> Something like an irq flags deprecation in the past:
>> http://lwn.net/Articles/229673/
>> ?
> 
> good catch,but this need to be modified (add one line is enough)to cause their use to
> cause __deprecated warnings.

I'm lost, that inline does it, right?
