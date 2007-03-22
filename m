Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbXCVIWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbXCVIWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXCVIWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:22:06 -0400
Received: from poczta.o2.pl ([193.17.41.142]:32833 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752104AbXCVIWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:22:04 -0400
Date: Thu, 22 Mar 2007 09:26:34 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J\. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] lockdep: lockdep_depth vs. debug_locks Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070322082634.GA2426@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru> <20070321181635.GA570@tv-sign.ru> <20070322061119.GA1466@ff.dom.local> <20070321222802.0e09f0c2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321222802.0e09f0c2.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:28:02PM -0800, Andrew Morton wrote:
> On Thu, 22 Mar 2007 07:11:19 +0100 Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > 
> > Here is some joke:
> > 
> > [PATCH] lockdep: lockdep_depth vs. debug_locks
> > 
> > lockdep really shouldn't be used when debug_locks == 0!
> > 
> 
> This isn't a very good changelog.

Actually it's not a changelog (it's a joke).

Jarek P.
