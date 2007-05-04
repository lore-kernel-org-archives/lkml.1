Return-Path: <linux-kernel-owner+w=401wt.eu-S1030576AbXEDQBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbXEDQBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030950AbXEDQBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:01:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58819 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030576AbXEDQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:01:23 -0400
Subject: Re: [PATCH 00/40] Swap over Networked storage -v12
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
In-Reply-To: <1178293081.24217.46.camel@twins>
References: <20070504102651.923946304@chello.nl>
	 <1178292179.7997.12.camel@imap.mvista.com>
	 <1178293081.24217.46.camel@twins>
Content-Type: text/plain
Date: Fri, 04 May 2007 08:59:39 -0700
Message-Id: <1178294379.7997.26.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 17:38 +0200, Peter Zijlstra wrote:
> > 
> > This is kind of a lot of patches all at once .. Have you release any of
> > these patch sets prior to this release ? 
> 
> Like the -v12 suggests, this is the 12th posting of this patch set.
> Some is the same, some has changed.

I can find one prior release with this subject (-v11) , what was the
subject prior to that release? It's not a hard rule, but usually >15
patches is too many (check Documentation/SubmittingPatches under
references).. You might want to consider submitting a URL instead. 

I think it's a benefit to release less since a developer (like myself)
might know very little about "Swap over Networked storage", but if you
submit 10 patches that developer might still review it, 40 patches they
likely wouldn't review it.

Daniel

