Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZLABIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZLABIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZLABIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:08:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36680 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZLABIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hkAhr/JBWadLXUg5HGCs0iQdViCT+HgQocVu0umB1XfPExYtTMpHvEGQzdt2F9VjaJ
         8XRTJdNSn7GMlqL97GOx20v/kucLtRR3he82aNRImKhtFBpKQHgAPRgOA0IHwCgDguBb
         6rYvInwIlvM/hxt41GPaYxAAhx1+XokAS7hIw=
Message-ID: <4B146CBD.4020307@gmail.com>
Date: Tue, 01 Dec 2009 09:09:17 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Brown, Len" <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Subject: [PATCH 2/2] fix a Section mismatch in arch/x86/pci/mmconfig-shared.c
 and include/linux/sfi_acpi.h
References: <4B13A094.2080504@126.com> <4B141A8E.1090104@zytor.com>
In-Reply-To: <4B141A8E.1090104@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hi Len,
>
> Do you want to take this one or should I?
>   
ooh! both ok！thing is that we fix the problem!
> 	-hpa
>
>
> On 11/30/2009 02:38 AM, helight wrote:
>   
>> acpi_sfi_table_parse() should be __init. tested on x86 system!
>>     
>
>   


-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org

