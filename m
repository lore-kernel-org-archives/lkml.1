Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbYD3MLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbYD3MLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759617AbYD3MKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:10:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762982AbYD3MKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:10:12 -0400
Date: Wed, 30 Apr 2008 14:09:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to
	discrete layout v8 - fix
Message-ID: <20080430120949.GB30735@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804290200.33459.yhlu.kernel@gmail.com> <200804290352.33543.yhlu.kernel@gmail.com> <200804292025.58268.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804292025.58268.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> v9: address format change requests by Ingo
>     more case handling in range_to_var_with_hole

thanks, applied.

	Ingo
