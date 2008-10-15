Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYJOVz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYJOVz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYJOVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:55:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:37184 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751839AbYJOVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:55:11 -0400
Message-ID: <48F666BA.9040104@ru.mvista.com>
Date: Thu, 16 Oct 2008 01:55:06 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hpt366: add hpt3xx_disable_fast_irq() helper
References: <200808021915.03424.bzolnier@gmail.com> <48F50649.9080507@ru.mvista.com> <200810152011.18478.bzolnier@gmail.com> <48F65E48.8080301@ru.mvista.com>
In-Reply-To: <48F65E48.8080301@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I just wrote:

>> Not such a big deal, we just have to make an another one...
>>
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Subject: [PATCH] hpt366: fix compile warning
>>
>> Fixup for commit 1785192b5310ee25165768f5bb80f13146788e3e
>> ("hpt366: add hpt3xx_disable_fast_irq() helper"):
>>
>>    CC      drivers/ide/pci/hpt366.o
>> drivers/ide/pci/hpt366.c: In function `init_hwif_hpt366':
>> drivers/ide/pci/hpt366.c:1290: warning: unused variable `dev'
>>
>> Reported-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>   
>
>   Duh. I've posted this patch a bit earlier. ;-)

   No, you were the first, so just add my:

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


