Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZGHSHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZGHSHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZGHSHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:07:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46105
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbZGHSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:07:33 -0400
Date: Wed, 08 Jul 2009 11:07:36 -0700 (PDT)
Message-Id: <20090708.110736.267641562.davem@davemloft.net>
To: jolsa@redhat.com
Cc: eric.dumazet@gmail.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       a.p.zijlstra@chello.nl, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090708174748.GB4650@jolsa.lab.eng.brq.redhat.com>
References: <20090707145710.GB7124@Krystal>
	<4A536866.1050906@gmail.com>
	<20090708174748.GB4650@jolsa.lab.eng.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>
Date: Wed, 8 Jul 2009 19:47:48 +0200

> great, I saw you Signed-off the 1/2 part.. could I leave it,
> or do I need to resend as a single patch?

Could you formally resubmit things, regardless of whether
they are kept split up or combined?  That will help me
a lot.  Thanks.

I think things are settled down at this point and we can
push these patches into the tree.
