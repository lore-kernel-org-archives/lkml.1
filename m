Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbZCVOPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbZCVOPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZCVOO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:14:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41347 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZCVOO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:14:59 -0400
Date: Sun, 22 Mar 2009 15:14:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/4] tracing: add ring_buffer_event_discard() to ring
	buffer
Message-ID: <20090322141435.GA29751@elte.hu>
References: <1237710649.7703.47.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237710649.7703.47.camel@charm-linux>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> This patch overloads RINGBUF_TYPE_PADDING to provide a way to discard
> events from the ring buffer, for the event-filtering mechanism
> introduced in a subsequent patch.
> 
> I did the initial version but thanks to Steven Rostedt for adding the
> parts that actually made it work. ;-)

I suspect it's signed-off-by both of you?

	Ingo
