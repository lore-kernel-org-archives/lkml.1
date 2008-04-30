Return-Path: <linux-kernel-owner+w=401wt.eu-S1763544AbYD3MoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763544AbYD3MoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbYD3MoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:44:08 -0400
Received: from www.tglx.de ([62.245.132.106]:47582 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006AbYD3MoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:44:06 -0400
Date: Wed, 30 Apr 2008 14:43:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
In-Reply-To: <20080430053814.06611928.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804301441510.6003@apollo.tec.linutronix.de>
References: <1209557398-8228-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0804301432080.6003@apollo.tec.linutronix.de> <20080430053814.06611928.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1473037258-1209559386=:6003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1473037258-1209559386=:6003
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 30 Apr 2008, Andrew Morton wrote:

> On Wed, 30 Apr 2008 14:32:58 +0200 (CEST) Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Wed, 30 Apr 2008, Uwe Kleine-König wrote:
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > I have the fixed version already queued for linus since yesterday :)
> > 
> 
> Where is it queued?

In my crap pile which is in preparation for a git update of
http://git.kernel.org/?p=linux/kernel/git/tglx/linux-2.6-genirq.git
 
Thanks,
	tglx

--8323328-1473037258-1209559386=:6003--
