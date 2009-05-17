Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZEQTG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZEQTG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZEQTGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:06:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZEQTGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:06:15 -0400
Message-ID: <4A105E37.5060704@redhat.com>
Date: Sun, 17 May 2009 21:57:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -tip] x86: kvm/x86.c use MSR names in place of address
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>	 <1242032701.3114.4.camel@localhost.localdomain>	 <1242032889.8213.32.camel@yhuang-dev.sh.intel.com> <1242279010.4574.6.camel@localhost.localdomain>
In-Reply-To: <1242279010.4574.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> [PATCH -tip] x86: kvm/x86.c use MSR names in place of address
>
> Replace 0xc0010010 with MSR_K8_SYSCFG and 0xc0010015 with MSR_K7_HWCR.
>
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

