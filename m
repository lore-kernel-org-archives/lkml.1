Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZALJUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZALJUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZALJUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:20:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZALJUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:20:00 -0500
Date: Mon, 12 Jan 2009 10:19:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: include apicnum.h in acpidef.h
Message-ID: <20090112091952.GI26750@elte.hu>
References: <496AD835.6000509@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496AD835.6000509@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: clean up
> 
> it seems Ingo revert it wrongly.
> put it back again
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

do you mean you submitted the patch and i didnt apply it or had to revert 
it? It never touched upstream so it must have been reverted due to some 
build failure or similar thing.

	Ingo
