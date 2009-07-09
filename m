Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZGITCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZGITCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 15:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZGITCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 15:02:38 -0400
Received: from www.tglx.de ([62.245.132.106]:34078 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbZGITCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 15:02:38 -0400
Date: Thu, 9 Jul 2009 21:01:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 20/44] includecheck fix: x86, shadow.c
In-Reply-To: <84144f020907091129q14880d4aqeae964621f8e6ca8@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0907092059110.2768@localhost.localdomain>
References: <1247063308.4382.12.camel@ht.satnam>  <1247065179.4382.51.camel@ht.satnam> <20090709162807.GD5208@lenovo>  <alpine.LFD.2.00.0907092016360.2768@localhost.localdomain> <84144f020907091129q14880d4aqeae964621f8e6ca8@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Pekka Enberg wrote:
> On Thu, Jul 9, 2009 at 9:18 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
> > Can we stop this kindergarden already? The patch is so obvious that it
> > just should be applied. I'll pick up all x86 ones and fold them in.
> 
> What kindergarten are you talking about? Technically Ingo "kicked"
> kmemcheck out of the x86 tree so the patch should go through
> kmemcheck.git which makes Cyrill's CC correction spot on.

I'm referring to the fact that these changes are so obvious that we do
neither need dozens separate commits nor the ack of everyone plus some
more. My inbox is full enough already.

Thanks,

	tglx
