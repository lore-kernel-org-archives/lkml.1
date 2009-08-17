Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbZHQW7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbZHQW7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZHQW7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:59:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbZHQW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:59:31 -0400
Date: Mon, 17 Aug 2009 15:59:42 -0700 (PDT)
Message-Id: <20090817.155942.143261709.davem@davemloft.net>
To: mingo@elte.hu
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, akpm@linux-foundation.org,
       nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
 enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090817224727.GA13795@elte.hu>
References: <20090817215808.GB15016@elte.hu>
	<20090817.153326.69833512.davem@davemloft.net>
	<20090817224727.GA13795@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 18 Aug 2009 00:47:27 +0200

> Also, has the review feedback from the tracing folks been 
> addressed? Please separate these patches out and lets do this 
> properly, this approach is not acceptable.

Fine, will keep you guys in the loop next time :-)
