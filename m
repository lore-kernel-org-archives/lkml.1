Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYIYMxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYIYMxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYIYMxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:53:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbYIYMxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:53:43 -0400
Date: Thu, 25 Sep 2008 14:53:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch -tip 2/3] Tracing/ftrace: Don't consume unhandled
	entries by boot tracer
Message-ID: <20080925125331.GA12766@elte.hu>
References: <48DB833A.9010103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48DB833A.9010103@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> When the boot tracer can't handle an entry output, it returns 1.
> It should return 0 to relay on other output functions.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/fastboot, thanks Frédéric!

	Ingo
