Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXKAVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXKAVQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXKAVQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:16:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:44563 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbXKAVQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:16:07 -0400
Message-ID: <472A4229.60808@qumranet.com>
Date: Thu, 01 Nov 2007 23:16:25 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] kvm: fix !SMP build error
References: <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org> <471F03F5.7090608@qumranet.com> <20071024123258.GA28653@elte.hu> <20071024123650.GA31562@elte.hu> <20071024181107.GA15250@elte.hu> <20071031203442.7e161692.rdunlap@xenotime.net> <20071101083139.GB8459@elte.hu> <4729D051.5040508@qumranet.com> <20071101145916.GA4044@elte.hu>
In-Reply-To: <20071101145916.GA4044@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> I thought you were handling it, as they aren't part of kvm proper.  
>> But I can send them, sure.
>>     
>
> i've got them in my queue already so i'll send them in the next 
> scheduler batch, ok?
>   

Thanks.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

