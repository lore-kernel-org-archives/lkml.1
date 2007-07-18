Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbXGRJgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbXGRJgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXGRJfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:35:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:57850 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbXGRJfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:35:53 -0400
Message-ID: <469DDEF7.7020107@qumranet.com>
Date: Wed, 18 Jul 2007 12:35:51 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
References: <11846910642166-git-send-email-avi@qumranet.com> <200707180225.31160.caglar@pardus.org.tr> <469D52F4.8090909@codemonkey.ws> <200707181231.35628.caglar@pardus.org.tr>
In-Reply-To: <200707181231.35628.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 18 Jul 2007 12:35:51 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
>
> 18 Tem 2007 Çar tarihinde, Anthony Liguori şunları yazmıştı: 
>   
>> Can you reproduce without the appArmor patchset?
>>     
>
> If needed http://cekirdek.pardus.org.tr/~caglar/kvm/netconsole is the appArmor 
> patchset included kernel's output captured with netconsole and yes i'll try 
> to reproduce same with vanilla one whenever i found some time :)
>
>   

It does look AppArmor related.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

