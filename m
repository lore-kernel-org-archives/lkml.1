Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYJYS5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYJYS5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYJYS5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:57:39 -0400
Received: from h155.mvista.com ([63.81.120.155]:6900 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbYJYS5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:57:38 -0400
Message-ID: <49036C17.1060604@ru.mvista.com>
Date: Sat, 25 Oct 2008 22:57:27 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: benh@kernel.crashing.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: linux-next: Tree for October 24 - powerpc - build failure with
 !CONFIG_BLK_DEV_IDEDMA_PMAC
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au> <49024EA3.1080404@ru.mvista.com> <1224889818.7654.466.camel@pasglop> <200810251519.57543.bzolnier@gmail.com>
In-Reply-To: <200810251519.57543.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>>>    Hm, looks like this configuration was never buildable -- #ifdef's are missing and wrongly placed. CCing Ben Herrenschmidt...   
>>>>>           
>>>> What configuration ?
>>>>   
>>>>         
>>>    See the subject.
>>>       
>> Ah ok. We should probably just remove the option...
>>     
>
> Fine with me.  Anybody want an easy +1 patch-point? :)
>   

   BTW, why this option selects BLK_DEV_IDEDMA_PCI?

MBR, Sergei


