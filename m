Return-Path: <linux-kernel-owner+w=401wt.eu-S934114AbYD1NVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114AbYD1NVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763455AbYD1NVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:21:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48569 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760510AbYD1NVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:21:17 -0400
Date: Mon, 28 Apr 2008 09:21:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 0/5] updates to ftrace framework and mmiotrace
In-Reply-To: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0804280920060.813@gandalf.stny.rr.com>
References: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 27 Apr 2008, Pekka Paalanen wrote:
>
> This resulted in the function trace_seq_to_user() which comes in the
> first patch. Just like the code I refactored, it does not touch filp
> or ppos. I trust the original author better than myself in this one :-)

If you are talking about me as the original author, then I wouldn't trust
me on ppos ;-).  I believe I screwed that part up. I'm about to go write
some patches for the read functions now.

-- Steve

