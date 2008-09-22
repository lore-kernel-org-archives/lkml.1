Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbYIVJgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbYIVJgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYIVJgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:36:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYIVJgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:36:17 -0400
Date: Mon, 22 Sep 2008 11:36:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: =?utf-8?B?RnLpppjpp7tpYw==?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>
Subject: Re: [Patch 1/3] Tracing/ftrace: Make nop tracer reset previous
	entries
Message-ID: <20080922093604.GA17258@elte.hu>
References: <48D68E06.50504@gmail.com> <20080922121237.13D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080922121237.13D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> your patch seems corrupted.
> please check again your e-mail client settings.

i fixed the extra newlines up and applied the patches to 
tip/tracing/ftrace, thanks Frédéric!

please check Documentation/email-clients.txt about details. There were 
two problems i saw: overlong lines in the commit description and extra 
'double newlines' in the patch itself. (To get around gmail limitations 
you can send -tip patches as MIME attachments as well.)

	Ingo
