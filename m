Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXHKKvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXHKKvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 06:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbXHKKvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 06:51:32 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:13057 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXHKKvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 06:51:31 -0400
Subject: Re: 2.6.23-rc2-mm2 build error on MIPS and ARM
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070811095658.GA11651@uranus.ravnborg.org>
References: <20070811025802.GA15885@Krystal>
	 <1186825800.32314.2.camel@localhost>
	 <20070811095658.GA11651@uranus.ravnborg.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 11 Aug 2007 12:54:57 +0200
Message-Id: <1186829697.3930.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-11 at 11:56 +0200, Sam Ravnborg wrote:
> > That attached patch should fix it for arm and mips. I'll try a few more
> > architectures until I'm fed up with compiling cross-compilers..
> http://userweb.kernel.org/~akpm/cross-compilers/

Thanks for the hint but I prefer to compile them on my own (naming
scheme, installation target, 4.1.2, ..). The first one is the hardest,
for the following ones it is just a matter how fast you machine is.
I'll do one cross-compiler every 15 minutes right now (without glibc).

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


