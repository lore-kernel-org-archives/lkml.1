Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZLALjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZLALjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZLALjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:39:19 -0500
Received: from mail.turknet.net.tr ([193.192.98.182]:11092 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZLALjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:39:19 -0500
Message-ID: <4B15006C.2020207@netone.com.tr>
Date: Tue, 01 Dec 2009 13:39:24 +0200
From: Tarkan Erimer <tarkane@netone.com.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.8 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.32-rc8-git2 Fails To Compile With GCC-4.4.2
References: <4B14FB56.4040608@netone.com.tr> <1259666631.23038.7.camel@tara.firmix.at>
In-Reply-To: <1259666631.23038.7.camel@tara.firmix.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Dec 2009 11:39:25.0033 (UTC) FILETIME=[EEBB9D90:01CA727A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 01:23 PM, Bernd Petrovitsch wrote:
> On Tue, 2009-12-01 at 13:17 +0200, Tarkan Erimer wrote:
>   
>> I wanted to compile linux-2.6.32-rc8-git2 with gcc-4.2.2 on opensuse
>> 11.2. But, it failed with the following error :
>>
>> PS: When I googled, I found the same error on Ubuntu Lucid forums with
>> gcc-4.4.2, too.
>>     
> [...]
>   
>> CC kernel/audit_tree.o
>> kernel/audit_tree.c: In function ‘find_chunk’:
>> kernel/audit_tree.c:206: internal compiler error: Segmentation fault
>> Please submit a full bug report,
>> with preprocessed source if appropriate.
>>     
> That's a clear gcc bug. So please throw it in their bugzilla (or whatever they hav).
>   
OK, I will. Thanks for pointing.
