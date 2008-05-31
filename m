Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYEaILG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYEaILG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYEaIKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:10:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYEaIKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:10:52 -0400
Date: Sat, 31 May 2008 10:10:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem
	error
Message-ID: <20080531081036.GA1449@elte.hu>
References: <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com> <20080508234016.GA14169@linux-os.sc.intel.com> <482392C4.7080901@zytor.com> <20080509003424.GA19710@linux-os.sc.intel.com> <20080529190143.GA26185@linux-os.sc.intel.com> <483F2566.2060102@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483F2566.2060102@numericable.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4057]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rufus & Azrael <rufus-azrael@numericable.fr> wrote:

> Hi Venki,
>
> I try your patch above and it works fine for my config, as your 
> previous patch.

thanks - i've applied Venki's fix to tip/x86/urgent.

	Ingo
