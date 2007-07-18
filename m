Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbXGRKbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbXGRKbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXGRKbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:31:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:35316 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXGRKbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:31:34 -0400
Message-ID: <469DEC04.8000503@qumranet.com>
Date: Wed, 18 Jul 2007 13:31:32 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
References: <11846910642166-git-send-email-avi@qumranet.com> <200707181231.35628.caglar@pardus.org.tr> <469DDEF7.7020107@qumranet.com> <200707181309.11900.caglar@pardus.org.tr>
In-Reply-To: <200707181309.11900.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 18 Jul 2007 13:31:32 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
>
> 18 Tem 2007 Çar tarihinde, Avi Kivity şunları yazmıştı: 
>   
>> S.Çağlar Onur wrote:
>>     
>>> Hi;
>>>
>>> 18 Tem 2007 Çar tarihinde, Anthony Liguori şunları yazmıştı:
>>>       
>>>> Can you reproduce without the appArmor patchset?
>>>>         
>>> If needed http://cekirdek.pardus.org.tr/~caglar/kvm/netconsole is the
>>> appArmor patchset included kernel's output captured with netconsole and
>>> yes i'll try to reproduce same with vanilla one whenever i found some
>>> time :)
>>>       
>> It does look AppArmor related.
>>     
>
> http://cekirdek.pardus.org.tr/~caglar/kvm/netconsole_wo_apparmor is the 
> vanilla one's netconsole output, by the way without apparmor patchset system 
> not hard freezes.
>   

This trace is certainly a kvm bug.  What guest are you running?  If it
is free (and does not contain private information), can you post it
somewhere for me to download?




-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

