Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZH1Vdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZH1Vdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZH1Vdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:33:49 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:40555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752934AbZH1Vdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:33:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
X-Fcc: ~/Mail/linus
Cc: <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix vdso32 relocation for paddr
In-Reply-To: Jan Kratochvil's message of  Friday, 28 August 2009 23:07:11 +0200 <20090828210711.GA9980@host0.dyn.jankratochvil.net>
References: <20090826223126.GA20373@host0.dyn.jankratochvil.net>
	<2375c9f90908280213i520e75a2wed97781ab2cd37ca@mail.gmail.com>
	<20090828181534.0823745B02@magilla.sf.frob.com>
	<20090828210711.GA9980@host0.dyn.jankratochvil.net>
Emacs: (setq software-quality (/ 1 number-of-authors))
Message-Id: <20090828213344.061EB45B02@magilla.sf.frob.com>
Date: Fri, 28 Aug 2009 14:33:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 28 Aug 2009 20:15:34 +0200, Roland McGrath wrote:
> > Thanks for heads-up.  It's definitely right to CC me on patches that change
> > the build/setup vDSO details.
> 
> OK, I thought more about {p,u}trace.

It so happens I'm also the vDSO and ELF-magic guru for the kernel.
It's an unrelated hat.

> Updated.  Verified on x86_64 host it works right for an i386 binary.

Looks good to me!


Thanks,
Roland
