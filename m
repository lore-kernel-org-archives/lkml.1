Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYGIGC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYGIGC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYGIGCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:02:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYGIGCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:02:20 -0400
Date: Wed, 9 Jul 2008 08:02:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] - Map UV chipset space - UV support
Message-ID: <20080709060204.GD9760@elte.hu>
References: <20080701194538.GA28410@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701194538.GA28410@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Create page table entries to map the SGI UV chipset GRU. local MMR & 
> global MMR ranges.

applied to tip/x86/core, thanks Jack.

	Ingo
