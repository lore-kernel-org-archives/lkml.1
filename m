Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZHYJe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZHYJe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZHYJeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:34:25 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49130 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbZHYJeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:34:23 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory  (f6f6e1a4), by kmemleak's scan_block()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <84144f020908250231k30ff4e9do20856bd1291f418c@mail.gmail.com>
References: <20090825071959.GA25877@elte.hu>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191507.26351.0.camel@penberg-laptop>
	 <1251192069.15678.21.camel@pc1117.cambridge.arm.com>
	 <1251192415.26351.5.camel@penberg-laptop>
	 <1251192534.15678.29.camel@pc1117.cambridge.arm.com>
	 <84144f020908250231k30ff4e9do20856bd1291f418c@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 25 Aug 2009 10:34:07 +0100
Message-Id: <1251192847.15678.35.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2009 09:34:08.0852 (UTC) FILETIME=[3241E940:01CA2567]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 12:31 +0300, Pekka Enberg wrote:
> On Tue, Aug 25, 2009 at 12:28 PM, Catalin
> Marinas<catalin.marinas@arm.com> wrote:
> >> Does this look OK to you?
> >
> > For the kmemleak.c part:
> >
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Vegard? Ingo? The patch is based on tip/out-of-tree so it probably
> should go to the kmemleak tree?

With the relevant ack, I can merge it in the kmemleak tree and push it
to Linus when the window opens.

-- 
Catalin

