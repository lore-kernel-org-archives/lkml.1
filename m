Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYKQTce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYKQTce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYKQTb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:31:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42197
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbYKQTb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:31:58 -0500
Date: Mon, 17 Nov 2008 11:31:58 -0800 (PST)
Message-Id: <20081117.113158.200497613.davem@davemloft.net>
To: mingo@elte.hu
Cc: dada1@cosmosbay.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117161135.GE12081@elte.hu>
References: <20081117110119.GL28786@elte.hu>
	<4921539B.2000002@cosmosbay.com>
	<20081117161135.GE12081@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Nov 2008 17:11:35 +0100

> Ouch, +4% from a oneliner networking change? That's a _huge_ speedup 
> compared to the things we were after in scheduler land.

The scheduler has accounted for at least %10 of the tbench
regressions at this point, what are you talking about?
