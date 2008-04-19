Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbYDSLKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbYDSLKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 07:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYDSLKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 07:10:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53269
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbYDSLKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 07:10:33 -0400
Date: Sat, 19 Apr 2008 04:10:34 -0700 (PDT)
Message-Id: <20080419.041034.33055901.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
 latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080419104152.GB13599@elte.hu>
References: <20080419100034.GA9475@elte.hu>
	<20080419.030736.168169087.davem@davemloft.net>
	<20080419104152.GB13599@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 19 Apr 2008 12:41:52 +0200

> thanks David, this solves the build failure here.
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks for testing.

I guess if you had been able to reply to the merge request
thread, this would have been fixed faster, sorry about that.
