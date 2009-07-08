Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZGHJPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZGHJPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbZGHJPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:15:39 -0400
Received: from av7-2-sn3.vrr.skanova.net ([81.228.9.182]:36044 "EHLO
	av7-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbZGHJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:15:38 -0400
Message-ID: <4A5463B4.2010403@mocean-labs.com>
Date: Wed, 08 Jul 2009 11:15:32 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [spi-devel-general] [RESEND][PATCH] SPI: xilinx_spi: Added platform
 driver and support for DS570
References: <4A366622.2050606@mocean-labs.com> <200906231237.54278.david-b@pacbell.net> <4A41DF44.4060705@mocean-labs.com> <200907021809.01990.david-b@pacbell.net>
In-Reply-To: <200907021809.01990.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/09 3:09 AM, David Brownell wrote:
> On Wednesday 24 June 2009, Richard Röjfors wrote:
>> On 09-06-23 21.37, David Brownell wrote:
>>> On Monday 15 June 2009, Richard Röjfors wrote:
>>>> This patch splits xilinx_spi into three parts, an OF and a platform
>>>> driver and generic part.
>>>>
>>>> The generic part now also works on X86 and also supports the Xilinx
>>>> SPI IP DS570
>>> Your Kconfig still mentions only DS464.
>> Correct, will update.
>
> Just checking -- you didn't send an update yet, right?

Nope not yet. I will send it within the next weeks, I'm actually on 
vacation.

--Richard
