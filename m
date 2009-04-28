Return-Path: <linux-kernel-owner+w=401wt.eu-S1763399AbZD1R0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763399AbZD1R0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbZD1R0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:26:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761302AbZD1R0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:26:09 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       kosaki.motohiro@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tzanussi@gmail.com, linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for worklet lifecycle tracing
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
	<20090415011533.GI5968@nowhere>
	<20090415141250.AC46.A69D9226@jp.fujitsu.com>
	<49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com>
	<20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
	<20090424130616.a3c217cb.akpm@linux-foundation.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 28 Apr 2009 13:24:57 -0400
In-Reply-To: <20090424130616.a3c217cb.akpm@linux-foundation.org> (Andrew Morton's message of "Fri, 24 Apr 2009 13:06:16 -0700")
Message-ID: <y0mr5zclmhi.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> [...]  The patches introduce a moderate amount of tracing-specific
> hooks into the core workqueue code, which inevitably increases the
> maintenance load for that code.  It is important that it be
> demonstrated that the benefts of the code are worth that cost.
> Hence it is important that these benefits be demonstrated to us, by
> yourself.  Please.  [...]

To be fair, if you ask for someone to specify and quantify the
"benefits" side of this, shouldn't someone specify and quantify the
"cost" side of this too?  That way we would have something to compare.


- FChE
