Return-Path: <linux-kernel-owner+w=401wt.eu-S965992AbXEVS2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965992AbXEVS2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbXEVS2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:28:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:12042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbXEVS2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=f5E0kH0pPk9f6ZyZavnIOtjfkFzwD9ca1tMmUSSnwejK16kmff9sSfzYi9NhiVtrjqpVwTrUpb9LISeqXxIpDwpFwvGz9tqz42lr1G2s3tn9YOfdkRV2ZrwDYCuHT1mitoM5cEVfmisCLzoGiU6fmItcJEIz89wa4K3Bmdyzksk=
Message-ID: <4653360A.5050907@googlemail.com>
Date: Tue, 22 May 2007 20:27:22 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Luigi Genoni <l.genoni@oltrelinux.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: at mm/slab.c:777 __find_general_cachep()
References: <200705221835.11559.l.genoni@oltrelinux.com>	 <6bffcb0e0705220940p22275f1dk46942db747c0a2e0@mail.gmail.com> <a781481a0705220946v1c94e0a0r897e6811abcd23c4@mail.gmail.com>
In-Reply-To: <a781481a0705220946v1c94e0a0r897e6811abcd23c4@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma napisał(a):
> On 5/22/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>> Hi Luigi,
>>
>> On 22/05/07, Luigi Genoni <l.genoni@oltrelinux.com> wrote:
>> > While doing eavy I/O on a RAID1 logical volume with reiserfs with
>> kernel
>> > 2.6.22-rc2 on Athlon64 3800+ X2, i got:
>> >
>> > BUG: at mm/slab.c:777 __find_general_cachep()
>>
>> Here is a patch
>> http://lkml.org/lkml/diff/2007/5/18/19/1
> 
> Eek, no ... he wants this one: http://lkml.org/lkml/diff/2007/5/16/513/1
> 

Is it a fix for http://lkml.org/lkml/2007/5/15/194 ?

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
