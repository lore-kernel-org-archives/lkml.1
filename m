Return-Path: <linux-kernel-owner+w=401wt.eu-S1423114AbXEDUCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423114AbXEDUCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422808AbXEDUCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:02:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36277
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031393AbXEDUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:02:52 -0400
Date: Fri, 04 May 2007 13:02:39 -0700 (PDT)
Message-Id: <20070504.130239.38710262.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       trond.myklebust@fys.uio.no, tgraf@suug.ch, James.Bottomley@SteelEye.com,
       michaelc@cs.wisc.edu, akpm@linux-foundation.org, phillips@google.com
Subject: Re: [PATCH 00/40] Swap over Networked storage -v12
From: David Miller <davem@davemloft.net>
In-Reply-To: <1178307709.2767.19.camel@lappy>
References: <20070504102651.923946304@chello.nl>
	<20070504.122716.31641374.davem@davemloft.net>
	<1178307709.2767.19.camel@lappy>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 04 May 2007 21:41:49 +0200

> How would you prefer I present these?

How about 8 or 9 at a time?  You are building infrastructure
and therefore you could post them 1 at a time for review
since each patch should be able to stand on it's own.
