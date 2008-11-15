Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYKOJXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYKOJXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 04:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYKOJXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 04:23:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:30131 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYKOJXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 04:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iwqfcKVadoKneV1qj7F6LAWnoGmVK8Bl/DERiPTocqDQc3efreZBMz8NUY/XX9YEIN
         O/5tUmuD48PGy4BI/WHaPP0BtYHRlTVCs3Lsf3EAoJjQxsY/PEMbeWw48lxrqM5va/7z
         VLKv7wZOUn639jeALaSUGXOi2ufUqlONWoXEU=
Message-ID: <491E94FD.4090002@gmail.com>
Date: Sat, 15 Nov 2008 12:23:09 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling mode
References: <1226722577.3104.4.camel@LiNuX> <20081114224321.ed9b1d7c.akpm@linux-foundation.org>
In-Reply-To: <20081114224321.ed9b1d7c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-acpi)
>
> On Fri, 14 Nov 2008 20:16:17 -0800 "Justin P. Mattock" <justinmattock@gmail.com> wrote:
>
>   
>> just pulled the latest git today and am now noticing
>> the lovely gpe storm being triggered.(dmesg below);
>>     
>
> Are any other effects observeable?
>
> I assume that 2.6.27 didn't do this.
>
>   
It did. Justin even opened a bug -- #11724.

