Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYKOKhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYKOKhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 05:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYKOKhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 05:37:09 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46119 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYKOKhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 05:37:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vcFlSBAN9suFJo7XGJgqMY5gwKX5zzfCBr/o7ts7lHZTab0Pu9dLNvWJDqNT9YeuJG
         eOaUCMggAMoeROWUTHHTkt4p2K7fvBOb3TbZ5kS03a43ksXTtD+5Yh++AD8y1yItyr2u
         Xn7BLYuvRExu9/EEnaHsqLk0yk0/H7aFxS5CI=
Message-ID: <9b2b86520811150237r454b0a38l8d34f0e322573da@mail.gmail.com>
Date: Sat, 15 Nov 2008 10:37:05 +0000
From: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling mode
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <491E94FD.4090002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226722577.3104.4.camel@LiNuX>
	 <20081114224321.ed9b1d7c.akpm@linux-foundation.org>
	 <491E94FD.4090002@gmail.com>
X-Google-Sender-Auth: fe084d4c569da3ef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 9:23 AM, Alexey Starikovskiy <aystarik@gmail.com> wrote:
> Andrew Morton wrote:
>>
>> (cc linux-acpi)
>>
>> On Fri, 14 Nov 2008 20:16:17 -0800 "Justin P. Mattock"
>> <justinmattock@gmail.com> wrote:
>>
>>  
>>>
>>> just pulled the latest git today and am now noticing
>>> the lovely gpe storm being triggered.(dmesg below);
>>>    
>>
>> Are any other effects observeable?
>>
>> I assume that 2.6.27 didn't do this.
>>
>>  
>
> It did. Justin even opened a bug -- #11724.

In case anyone else tries to follow that, it's actually #10724 :).
