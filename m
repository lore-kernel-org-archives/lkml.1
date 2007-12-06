Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXLFK4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXLFK4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXLFK4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:56:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbXLFK4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:56:03 -0500
Date: Thu, 6 Dec 2007 11:55:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH Latency Tracer] don't panic on failed bootmem alloc
Message-ID: <20071206105551.GC30838@elte.hu>
References: <1196916093.1645.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196916093.1645.41.camel@localhost.localdomain>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This patch prevents a panic on a failed bootmem alloc in the 
> initialization of the tracer buffers.

thanks, good catch!

	Ingo
