Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbZAGRok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbZAGRok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZAGRoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:44:20 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36711 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZAGRoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Qf7G2KE4UzfX3t0L6IqbVBHBH34JL0kdFxdICCI7H4Jh4SPU0UEnaL/Ww4alFSyxC9
         qkxHT8zooRvZHzp5ztUWRGcE/YXFOOIigSgXrxMQKasarkqrz0sLxkj7ZdFHGxH82wTB
         cCMtuBOJcxXdY4Vjc6+FmBHbC7nmGe2GW0yiQ=
Message-ID: <c4e36d110901070944v336fa45fi31f20653d3157232@mail.gmail.com>
Date: Wed, 7 Jan 2009 18:44:15 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: MCE error log
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <87bpuk46da.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901060500w289708d5ne252ace7a2fd9944@mail.gmail.com>
	 <87bpuk46da.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/6 Andi Kleen <andi@firstfloor.org>:
> "Zdenek Kabelac" <zdenek.kabelac@gmail.com> writes:
>
>> /sys/devices/system/machinecheck/machinecheck1
>> I could only see  bank0ctl ... bank5ctl - so where is bank 128 ?
>
> Update your mcelog. Newer versions decode it.

Ok

I've replaced binary with the latest code from you.

Here is new trace

MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 THERMAL EVENT TSC 54ab7bf6
Processor core below trip temperature. Throttling disabled
STATUS 88380100 MCGSTATUS 0

So what does this message means now ?

Zdenek
