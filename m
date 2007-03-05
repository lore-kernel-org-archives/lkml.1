Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbXCEC5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbXCEC5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXCEC53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:57:29 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46208 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbXCEC53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:57:29 -0500
Message-ID: <45EB8718.6050008@vmware.com>
Date: Sun, 04 Mar 2007 18:57:28 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] arch/i386/kernel/vmi.c must #include <asm/kmap_types.h>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070305014733.GO3441@stusta.de>
In-Reply-To: <20070305014733.GO3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>   
>> ...
>> Changes since 2.6.20-mm2:
>> ...
>> +vmi-fix-highpte.patch
>> ...
>>  2.6.21 queue
>> ...
>>     
>
> This patch fixes the following compile error:
>
>   

Includes changed, perhaps?  No idea why this broke, but fix looks good.

Acked-by: Zachary Amsden <zach@vmware.com>
