Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYBFPEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYBFPEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYBFPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:04:33 -0500
Received: from trashmail.net ([213.155.82.90]:36680 "EHLO trashmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYBFPEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:04:32 -0500
Message-ID: <47A9CCF4.7080108@trashmail.net>
Date: Wed, 06 Feb 2008 16:06:28 +0100
From: "rzryyvzy" <rzryyvzy@trashmail.net>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: What is the limit size of tmpfs /dev/shm ?
References: <47A9CA0E.3030507@wpkg.org>
In-Reply-To: <47A9CA0E.3030507@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski schrieb:
>> Hello Kernel Users,
>>
>> is there a size limit for tmpfs for the /dev/shm filesystem?
>> Normally its default size is set to 2 GB. Is it possible to create a 
>> 2 TB (Terrabyte) filesystem with tmpfs?
>> Or is there a maximum size defined in the linux kernel?
>
> Depends on your arch.
I have a 64 Bits architecture (amd64/x86_64).

> If you're 64 bit, you need to have really loads of storage and/or RAM 
> to accumulate 16EB:
>
> # mount -t tmpfs -o size=171798691839G tmpfs /mnt/2
> # df -h
> (...)
> tmpfs                  16E     0   16E   0% /mnt/2
Nice, I will try this out.
I have not the money for 16E of memory of RAM! :-) lol
Already to provide 1 TB it would cost at least for the memory about 20 
000 EUR + the server costs which support this.

-- 
Best regards
