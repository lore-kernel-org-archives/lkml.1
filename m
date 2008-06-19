Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYFSKja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYFSKja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbYFSKjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:39:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40697 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121AbYFSKjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:39:17 -0400
Date: Thu, 19 Jun 2008 12:39:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 5/5 v2] x86: PAT: make pat_x_mtrr_type() more readable
Message-ID: <20080619103900.GI15228@elte.hu>
References: <20080610140755.GI5024@alberich.amd.com> <20080616125821.GA5213@alberich.amd.com> <Pine.LNX.4.64.0806161753060.13075@blonde.site> <20080618133857.GB5213@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618133857.GB5213@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> [PATCH] x86: shrink pat_x_mtrr_type to its essentials
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

applied to tip/x86/pat - thanks Andreas.

now pat_x_mtrr_type() is not nearly as scary anymore :-)

	Ingo
