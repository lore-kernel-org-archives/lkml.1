Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZETIOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZETIOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZETIOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:14:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:59502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbZETIO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:14:29 -0400
Subject: Re: [PATCH -tip] x86: kvm replace MSR_IA32_TIME_STAMP_COUNTER with
 MSR_IA32_TSC of msr-index.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4A105BFD.6030309@redhat.com>
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
	 <1242032701.3114.4.camel@localhost.localdomain>
	 <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>
	 <1242279010.4574.6.camel@localhost.localdomain>
	 <1242282442.4574.11.camel@localhost.localdomain>
	 <1242393125.3082.4.camel@localhost.localdomain>
	 <4A105BFD.6030309@redhat.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 13:42:48 +0530
Message-Id: <1242807168.3260.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

On Sun, 2009-05-17 at 21:48 +0300, Avi Kivity wrote:
> Jaswinder Singh Rajput wrote:
> > If this patch looks sane to you can apply in kvm tree.
> >
> > Here is the updated patch based on kvm tree:
> >
> > [PATCH] x86: kvm replace MSR_IA32_TIME_STAMP_COUNTER with MSR_IA32_TSC of msr-index.h
> >
> > Use standard msr-index.h's MSR declaration.
> >
> > MSR_IA32_TSC is better than MSR_IA32_TIME_STAMP_COUNTER as it also solves
> > 80 column issue.
> >   
> 
> Applied, thanks.
> 

BTW, where you applied this patch.

git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git is still
showing old data.

Thanks,
--
JSR

