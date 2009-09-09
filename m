Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZIIXR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZIIXR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZIIXR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:17:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37577 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZIIXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:17:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, jpirko@redhat.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com, linux-mm@kvack.org,
       mingo@elte.hu
In-Reply-To: <20090909134643.5479b09e.akpm@linux-foundation.org>
References: <20090907115430.6C16.A69D9226@jp.fujitsu.com> <20090909134643.5479b09e.akpm@linux-foundation.org>
Message-Id: <20090910081020.9CAE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 08:17:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon,  7 Sep 2009 11:58:36 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > Grr, my fault.
> > > I recognize it. sorry.
> > 
> > I've finished my long pending homework ;)
> > 
> > Andrew, can you please replace following patch with getrusage-fill-ru_maxrss-value.patch
> > and getrusage-fill-ru_maxrss-value-update.patch?
> > 
> > 
> > 
> > ChangeLog
> >  ===============================
> >   o Merge getrusage-fill-ru_maxrss-value.patch and getrusage-fill-ru_maxrss-value-update.patch
> >   o rewrote test programs (older version hit FreeBSD bug and it obfuscate testcase intention, thanks Hugh)
> 
> The code changes are unaltered, so I merely updated the changelog.

I see. thanks.


> The changelog had lots of ^------- lines in it.  But those are
> conventionally the end-of-changelog separator so I rewrote them to
> ^=======

sorry, I have stupid question.
I thought "--" and "---" have special meaning. but other length "-" are safe.
Is this incorrect?

or You mean it's easy confusing bad style?



