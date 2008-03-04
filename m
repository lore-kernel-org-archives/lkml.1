Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbYCDUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbYCDUxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYCDUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:52:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbYCDUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:52:50 -0500
Date: Tue, 4 Mar 2008 21:52:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [patch] mark netconsole broken
Message-ID: <20080304205221.GA31054@elte.hu>
References: <20080206011643.d9021649.akpm@linux-foundation.org> <20080303210540.cea55e13.akpm@linux-foundation.org> <20080304080644.GC2947@elte.hu> <20080304.123031.242861949.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304.123031.242861949.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 4 Mar 2008 09:06:44 +0100
> 
> > i'd suggest the patch below, to mark it broken.
> 
> Why bother when we know what the bug is and can fix it? :-)

music to my ears :-)

	Ingo
