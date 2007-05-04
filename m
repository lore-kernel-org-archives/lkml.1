Return-Path: <linux-kernel-owner+w=401wt.eu-S1423096AbXEDT1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423096AbXEDT1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423079AbXEDT1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:27:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50091
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423078AbXEDT13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:27:29 -0400
Date: Fri, 04 May 2007 12:27:16 -0700 (PDT)
Message-Id: <20070504.122716.31641374.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       trond.myklebust@fys.uio.no, tgraf@suug.ch, James.Bottomley@SteelEye.com,
       michaelc@cs.wisc.edu, akpm@linux-foundation.org, phillips@google.com
Subject: Re: [PATCH 00/40] Swap over Networked storage -v12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070504102651.923946304@chello.nl>
References: <20070504102651.923946304@chello.nl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 04 May 2007 12:26:51 +0200

> There is a fundamental deadlock associated with paging;

I know you'd really like people like myself to review this work, but a
set of 40 patches is just too much to try and digest at once
especially when I have other things going on.  When I have lots of
other things already on my plate, when I see a huge patch set like
this I have to just say "delete" because I don't kid myself since
I know I'll never get to it.

Sorry there's now way I can review this with my current workload.
