Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZJZH5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZJZH5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZJZH5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:57:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:58398 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbZJZH5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,625,1249282800"; 
   d="scan'208";a="740441655"
Subject: Re: linux-next: Tree for October 26
From: Huang Ying <ying.huang@intel.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <a8e1da0910260053r245ee675yca4dc984303187df@mail.gmail.com>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
	 <a8e1da0910260050y527bdbcbt4171ad6d868fcb29@mail.gmail.com>
	 <a8e1da0910260053r245ee675yca4dc984303187df@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 15:57:19 +0800
Message-Id: <1256543839.30470.29.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, this should be turned off for x86_32. I will fix this.

Best Regards,
Huang Ying

On Mon, 2009-10-26 at 15:53 +0800, Dave Young wrote: 
> On Mon, Oct 26, 2009 at 3:50 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > Hi,
> >
> > build fails with ghash ghash-clmulni-intel_asm.S:
> 
> It is a x86_32 laptop
> 
> 
> >
> >  AS      arch/x86/crypto/ghash-clmulni-intel_asm.o
> > arch/x86/crypto/ghash-clmulni-intel_asm.S: Assembler messages:
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:100: Error: bad register name `%rdi)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:101: Error: bad register name `%rsi)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:106: Error: bad register name `%rdi)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:114: Error: bad register name `%rdx'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:117: Error: bad register name `%rdi)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:118: Error: bad register name `%rcx)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:122: Error: bad register name `%rsi)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:126: Error: bad register name `%rdx'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:127: Error: bad register name `%rsi'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:128: Error: bad register name `%rdx'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:131: Error: bad register name `%rdi)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:142: Error: bad register name `%rsi)'
> > arch/x86/crypto/ghash-clmulni-intel_asm.S:156: Error: bad register name `%rdi)'
> > make[2]: *** [arch/x86/crypto/ghash-clmulni-intel_asm.o] Error 1
> > make[1]: *** [arch/x86/crypto] Error 2
> > make: *** [arch/x86] Error 2
> > make: *** Waiting for unfinished jobs....
> >
> > cc herbert & huang ying
> >
> > --
> > Regards
> > dave
> >
> 
> 
> 

