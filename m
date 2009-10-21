Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZJUL7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZJUL7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZJUL7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:59:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43995 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbZJUL7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:59:43 -0400
Date: Wed, 21 Oct 2009 13:59:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: paulus@samba.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf record: Enable PERF_SAMPLE_ID when sampling
	multiple events
Message-ID: <20091021115935.GH16586@elte.hu>
References: <20091021061925.GW4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021061925.GW4808@kryten>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> If we are sampling multiple events we need the id in each sample so we 
> can differentiate between them in a perf data file.

Wondering, what are you (or will you be) using this for?

	Ingo
