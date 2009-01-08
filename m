Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbZAHUiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbZAHUiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZAHUiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:38:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbZAHUiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:38:46 -0500
Date: Thu, 8 Jan 2009 15:38:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] doc: update mmiotrace.txt
In-Reply-To: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0901081538080.28112@gandalf.stny.rr.com>
References: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jan 2009, Pekka Paalanen wrote:

> From 32fe58c5a4a162e9d6ab4aca91692e0e28167f97 Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Sat, 3 Jan 2009 21:09:27 +0200
> Subject: [PATCH] doc: update mmiotrace.txt
> 
> The tracing framework buffer size file in debugfs has changed.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>

Pekka,

Can you resubmit these with a better change log on the first two, and an 
Impact line on each.

Thanks,

-- Steve

