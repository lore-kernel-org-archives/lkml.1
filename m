Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbYCKJP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbYCKJP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbYCKJPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:15:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49547 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbYCKJPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:15:04 -0400
Date: Tue, 11 Mar 2008 10:14:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove redundant display of free swap space in
	show_mem()
Message-ID: <20080311091447.GI25110@elte.hu>
References: <87abl68rdd.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abl68rdd.fsf@saeurebad.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> From: Johannes Weiner <hannes@saeurebad.de>
> 
> show_free_areas() already displays free swap space, no need to do it a 
> second time in show_mem() which calls the former anyway.

thanks, applied.

	Ingo
