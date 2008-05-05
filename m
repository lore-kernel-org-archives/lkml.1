Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYEEHwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYEEHwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYEEHwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:52:37 -0400
Received: from www.tglx.de ([62.245.132.106]:50356 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbYEEHwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:52:36 -0400
Date: Mon, 5 May 2008 09:49:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrey Panin <pazke@pazke.donpac.ru>
cc: Glauber Costa <gcosta@redhat.com>, Hugh Dickins <hugh@veritas.com>,
       linux-visws-devel@lists.sourceforge.net,
       "J.A. Magall??n" <jamagallon@ono.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Problems with -git14
In-Reply-To: <20080505071300.GA3456@pazke.donpac.ru>
Message-ID: <alpine.LFD.1.10.0805050949110.3318@apollo.tec.linutronix.de>
References: <20080430015655.5a42f63d@werewolf.home> <Pine.LNX.4.64.0804301516580.30549@blonde.site> <4818962D.4040906@redhat.com> <20080505071300.GA3456@pazke.donpac.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Andrey Panin wrote:
> > However, since this problem was raised, I'm still concerned that visws may 
> > have the same problem, since it uses the same logic that i386 mach_default 
> > used to. (and I did not touched, since x86_64 code went int o 
> > mach_default).
> >
> > Could anyone with access to such hardware give it a try ?
> 
> Unfortunately, no. Visws port is in non-bootable state currently, 2.6.25 hangs
> in calibrate_delay_direct() and I still do not know why :(

What was the last kernel which booted on visws ?

Thanks,
	tglx
