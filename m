Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYDGIRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYDGIRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYDGIQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:16:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYDGIQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:16:57 -0400
Date: Mon, 7 Apr 2008 10:16:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Mike Travis <travis@sgi.com>, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: add cpus_scnprintf function v2
Message-ID: <20080407081643.GC3066@elte.hu>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com> <20080407030421.0c3f8033.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407030421.0c3f8033.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> I still have some concerns with this cpus_scnprintf patch.
> 
> I've taken them up with Mike offline for initial consideration.
> 
> If others have questions, concerns or enthusiasms for this patch, Mike 
> and I would be interested.

i dont mind the old patch either (which did an ugly temporary 
allocation), if it keeps the ABI. I dont think it's a big deal, lets not 
allow it to become a roadblock, and the overall goal of all these 
patches [4096 CPU support in upstream Linux] is important and i'm 
enthusiastic about that ;-)

	Ingo
