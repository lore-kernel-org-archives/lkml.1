Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbXBPWmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbXBPWmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXBPWmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:42:18 -0500
Received: from mail.tmr.com ([64.65.253.246]:45039 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXBPWmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:42:17 -0500
Message-ID: <45D633CC.3060309@tmr.com>
Date: Fri, 16 Feb 2007 17:44:28 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.20-get13] KVM-12 won't build
References: <45D5DC8D.7010609@tmr.com> <20070216170551.GA2188@amd.com>
In-Reply-To: <20070216170551.GA2188@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Fri, Feb 16, 2007 at 11:32:13AM -0500, Bill Davidsen wrote:
>   
>> Goes out with an error message:
>>
>>    cc -I /home/davidsen/downloads/kernel.org/linux-2.6.20-git13/include -MMD -MF ./.kvmctl.d 
>> -g   -c -o kvmctl.o kvmctl.c
>>    kvmctl.c:29:2: error: #error libkvm: userspace and kernel version mismatch
>>    make[1]: *** [kvmctl.o] Error 1
>>      
>> I don't see a kvm-13 on the KVM website.
>>     
>
> You will find the kvm-13 release in the SourceForge download area of
> KVM[1]. Kvm-12 is still required for 2.6.20 kernels.
>
> Joerg
>
> [1] http://sourceforge.net/project/showfiles.php?group_id=180599
>
>   
I'll look, the download off the home page didn't seem to have it.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

