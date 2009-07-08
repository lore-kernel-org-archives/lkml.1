Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZGHSQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZGHSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZGHSQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:16:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbZGHSQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:16:50 -0400
Date: Wed, 8 Jul 2009 20:16:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       a.p.zijlstra@chello.nl, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090708181619.GC4650@jolsa.lab.eng.brq.redhat.com>
References: <20090707145710.GB7124@Krystal> <4A536866.1050906@gmail.com> <20090708174748.GB4650@jolsa.lab.eng.brq.redhat.com> <20090708.110736.267641562.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708.110736.267641562.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:07:36AM -0700, David Miller wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> Date: Wed, 8 Jul 2009 19:47:48 +0200
> 
> > great, I saw you Signed-off the 1/2 part.. could I leave it,
> > or do I need to resend as a single patch?
> 
> Could you formally resubmit things, regardless of whether
> they are kept split up or combined?  That will help me
> a lot.  Thanks.
> 
> I think things are settled down at this point and we can
> push these patches into the tree.

np, I'll send out shortly complete v6 then..

jirka
