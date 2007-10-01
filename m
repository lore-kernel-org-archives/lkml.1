Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbXJAA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbXJAA1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 20:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXJAA1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 20:27:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34757
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbXJAA1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 20:27:04 -0400
Date: Sun, 30 Sep 2007 17:27:03 -0700 (PDT)
Message-Id: <20070930.172703.79041329.davem@davemloft.net>
To: val@nmt.edu
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rrbranco@br.ibm.com,
       twichell@us.ibm.com, ycai@us.ibm.com
Subject: Re: [ANNOUNCE] ebizzy 0.2 released
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070823010626.GC11402@rainbow>
References: <20070823010626.GC11402@rainbow>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Henson <val@nmt.edu>
Date: Wed, 22 Aug 2007 19:06:26 -0600

> ebizzy is designed to generate a workload resembling common web
> application server workloads.

I downloaded this only to be basically disappointed.

Any program which claims to generate workloads "resembling common web
application server workloads", and yet does zero network activity and
absolutely nothing with sockets is so far disconnected from reality
that I truly question how useful it really is even in the context it
was designed for.

Please describe this program differently, "a threaded cpu eater", "a
threaded memory scanner", "a threaded hash lookup", or something
suitably matching what it really does.

I'm sure there are at least 10 or even more programs in LTP that one
could run under "time" and get the same exact functionality.
