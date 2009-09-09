Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZIIXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZIIXh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZIIXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:37:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38026 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZIIXhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:37:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, jpirko@redhat.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com, linux-mm@kvack.org,
       mingo@elte.hu
In-Reply-To: <20090909163212.11464d64.akpm@linux-foundation.org>
References: <20090910081020.9CAE.A69D9226@jp.fujitsu.com> <20090909163212.11464d64.akpm@linux-foundation.org>
Message-Id: <20090910083727.9CBA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 08:37:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 10 Sep 2009 08:17:27 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > 
> > > The changelog had lots of ^------- lines in it.  But those are
> > > conventionally the end-of-changelog separator so I rewrote them to
> > > ^=======
> > 
> > sorry, I have stupid question.
> > I thought "--" and "---" have special meaning. but other length "-" are safe.
> > Is this incorrect?
> > 
> > or You mean it's easy confusing bad style?
> 
> Ideally, ^---$ is the only pattern we need to worry about.
> 
> In the real world, ^-------- might trigger people's sloppy scripts so
> it's best to be safe and avoid it altogether.

Ah I see.
Thank you! 



