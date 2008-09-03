Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYICXEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYICXEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYICXEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:04:40 -0400
Received: from www.tglx.de ([62.245.132.106]:35123 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbYICXEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:04:40 -0400
Date: Thu, 4 Sep 2008 01:04:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Nezhevenko <dion@inhex.net>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: [patch 0/6] final clockevents/hpet fixes
In-Reply-To: <20080903230003.GA1958@laptop.local>
Message-ID: <alpine.LFD.1.10.0809040102560.3243@apollo.tec.linutronix.de>
References: <20080903212735.713411776@linutronix.de> <20080903230003.GA1958@laptop.local>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Dmitry Nezhevenko wrote:
> On Wed, Sep 03, 2008 at 09:36:25PM -0000, Thomas Gleixner wrote:
> > This is the final version of the various clockevents fixes, which I will
> > send to Linus. Can you please give it a try on your machines, so we can
> > be sure that I did not mess up anything again.
> > 
> 
> Applied full patchset on top of 2.6.27-rc5. Works great on my affected system.
> 
> Tested-by: Dmitry Nezhevenko <dion@inhex.net>

Dimitry, thanks for testing.

Are you up for another debug session in the next days to figure out
why the x86 tree exposes this IPI warning ?

Thanks,

	tglx
