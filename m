Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbYCZME4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbYCZME4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYCZMEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:04:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYCZMEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:04:48 -0400
Message-ID: <47EA3B83.4090403@redhat.com>
Date: Wed, 26 Mar 2008 09:03:15 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       mingo@elte.hu, tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com
Subject: Re: [PATCH 0/20] dma_ops for i386
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com> <47EA1EF9.9080602@qumranet.com>
In-Reply-To: <47EA1EF9.9080602@qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Glauber Costa wrote:
>> Hello,
>>
>> Here there is a series of 20 patches that lays the foundations for
>> using dma_ops in i386 in the very same way x86_64, as well as many other
>> architectures already do.
>>
>> The functions themselves for i386 are placed in a pci-base_32.c, but just
>> a few among them are actually implemented. Most were no-ops anyway.
>>
>>   
> 
> I see the headers are unified, but the .c files are duplicated.  I 
> presume unifying the implementation is deferred to later patches?
presume correctly.

