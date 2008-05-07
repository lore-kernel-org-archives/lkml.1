Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbYEGHGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbYEGHGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYEGHGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:06:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36602 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702AbYEGHGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:06:30 -0400
Date: Wed, 7 May 2008 09:06:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with
	xf86MapVidMem error
Message-ID: <20080507070609.GE32195@elte.hu>
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <20080506225140.GB18706@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506225140.GB18706@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> ---
>  arch/x86/mm/pat.c      |    6 +++---
>  include/linux/kernel.h |    1 +
>  kernel/sysctl.c        |    8 ++++++++
>  3 files changed, 12 insertions(+), 3 deletions(-)

applied, thanks. Please also send the Documentation/kernel-parameters.txt
bits.

	Ingo
