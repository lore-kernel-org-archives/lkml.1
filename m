Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZJ0NwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZJ0NwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZJ0NwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:52:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbZJ0NwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:52:17 -0400
Date: Tue, 27 Oct 2009 14:52:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marti Raudsepp <marti@juffo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0 of 2] Two small UI tweaks to perf
Message-ID: <20091027135211.GD32628@elte.hu>
References: <patchbomb.1256603583@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1256603583@localhost>
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


* Marti Raudsepp <marti@juffo.org> wrote:

> Hi!
> 
> Posting two small user interface tweaks to perf.
> 
> [PATCH 1 of 2] perf tools: notify user when unrecognized event is specified
> 
> When you specify an unknown --event, perf now outputs:
> 
>   invalid or unsupported event: 'foobar'
>   Run 'perf list' for a list of valid events

ok, agreed!

> [PATCH 2 of 2] perf tools: output 'perf list' to stdout not stderr
> 
> I certainly expected 'perf list' output to be sent to stdout. It's not errors
> or notices: the user asked for a list.

Certainly - i meant to fix this for some time - thanks for taking care 
of it.

	Ingo
