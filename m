Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYIYM5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYIYM5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYIYM5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:57:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36011 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYIYM5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:57:04 -0400
Date: Thu, 25 Sep 2008 14:56:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Paalanen <pq@iki.fi>
Subject: Re: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries
	unhandled by mmiotrace
Message-ID: <20080925125658.GB12766@elte.hu>
References: <48DB8408.7080408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48DB8408.7080408@gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> When mmiotrace can't handle an entry output, it returns 1.
> It should return 0 to relay on other output functions.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/mmiotrace, thanks Frédéric!

	Ingo
