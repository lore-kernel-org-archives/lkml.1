Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZKMPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZKMPwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZKMPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:52:28 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:37194 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbZKMPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:52:27 -0500
Date: Fri, 13 Nov 2009 15:52:22 +0000
From: Martin Michlmayr <tbm@cyrius.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>, sam@ravnborg.org,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       akpm@linux-foundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Add support for LZO-compressed kernels for ARM
Message-ID: <20091113155222.GO13296@deprecation.cyrius.com>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
 <20091112125938.GA19698@deprecation.cyrius.com>
 <20091113142917.GA12149@Chamillionaire.breakpoint.cc>
 <20091113145008.GN13296@deprecation.cyrius.com>
 <20091113145349.GA2201@pc-ran3241.res.insa>
 <20091113152155.GC27752@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113152155.GC27752@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King <rmk+lkml@arm.linux.org.uk> [2009-11-13 15:21]:
> > >  make[4]: *** No rule to make target `arch/arm/boot/compressed/arch/arm/lib/lib1funcs.o', needed by `arch/arm/boot/compressed/vmlinux'.  Stop.
> > 
> > Sam: what's the correct way to solve this issue?
> 
> We already have something similar - with the font support.  Just do this:

That works.
-- 
Martin Michlmayr
http://www.cyrius.com/
