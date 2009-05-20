Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZETLse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZETLse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZETLsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:48:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35771 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZETLsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:48:24 -0400
Message-ID: <4A13EDBA.8010701@redhat.com>
Date: Wed, 20 May 2009 14:47:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -tip] x86: kvm replace MSR_IA32_TIME_STAMP_COUNTER with
 MSR_IA32_TSC of msr-index.h
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>	 <1242032701.3114.4.camel@localhost.localdomain>	 <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>	 <1242279010.4574.6.camel@localhost.localdomain>	 <1242282442.4574.11.camel@localhost.localdomain>	 <1242393125.3082.4.camel@localhost.localdomain>	 <4A105BFD.6030309@redhat.com> <1242807168.3260.54.camel@localhost.localdomain>
In-Reply-To: <1242807168.3260.54.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> BTW, where you applied this patch.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git is still
> showing old data.
>
>   

Sometimes things find their way into the queue branch.

-- 
error compiling committee.c: too many arguments to function

