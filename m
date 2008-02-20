Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbYBTJQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbYBTJQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYBTJPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:15:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56042 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbYBTJPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:15:52 -0500
Date: Wed, 20 Feb 2008 10:15:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] x86: Optimize percpu accesses v3
Message-ID: <20080220091529.GD31424@elte.hu>
References: <20080219203335.866324000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219203335.866324000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mike Travis <travis@sgi.com> wrote:

> This patchset is the x86-specific part split from the generic part of 
> the zero-based patchset.

thanks Mike, applied them to x86.git. Do these depend on the generic 
bits? (for now we'll keep these in -testing, so that they do not reach 
-mm)

	Ingo
