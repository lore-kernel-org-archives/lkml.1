Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbZBRWFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbZBRWFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZBRWFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:05:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50973
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbZBRWFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:05:10 -0500
Date: Wed, 18 Feb 2009 14:04:55 -0800 (PST)
Message-Id: <20090218.140455.142445208.davem@davemloft.net>
To: mingo@elte.hu
Cc: shemminger@vyatta.com, kaber@trash.net, rick.jones2@hp.com,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, tglx@linutronix.de,
       gandalf@wlug.westbo.se, linux-kernel@vger.kernel.org
Subject: Re: [RFT 2/4] Add mod_timer_noact
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090218215140.GA3505@elte.hu>
References: <20090218110144.GA4100@elte.hu>
	<20090218.133959.193699273.davem@davemloft.net>
	<20090218215140.GA3505@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 18 Feb 2009 22:51:40 +0100

> Anyway, it's all handled, you just need to read the rest of the 
> thread.

I did read the entire thread before replying, my objection
to your original posting still standed.

And as others have pointed out you also failed to recognize
the context of the patch posting.  It was part of a sequence
of patches for people to test some experimental netfilter
performance optimizations.  "RFT" was prefixed to every patch
subject line, if any more indication was necessary.

Yet you object that the patches are against the networking
and netfilter trees.

Again, your reactions were knee-jerk, by every definition of the
term.

I know how you work Ingo, you want to be fast and efficient.
But often, your "fast and efficient" is "careless", and this
wastes everyone elses time and in the final analysis makes
you "slow".
