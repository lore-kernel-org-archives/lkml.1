Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYJGVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYJGVI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYJGVIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:08:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54839
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbYJGVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:08:49 -0400
Date: Tue, 07 Oct 2008 14:08:25 -0700 (PDT)
Message-Id: <20081007.140825.40261432.davem@davemloft.net>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-netdev@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm,
 for adaptive dcache hash table sizing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081007064834.GA5959@wotan.suse.de>
References: <20081007064834.GA5959@wotan.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Tue, 7 Oct 2008 08:48:34 +0200

> I'm cc'ing netdev because Dave did express some interest in using this for
> some networking hashes, and network guys in general are pretty cluey when it
> comes to hashes and such ;)

Interesting stuff.

Paul, many months ago, forwarded to me a some work done by Josh
Triplett called "rcuhashbash" which had similar objectives.  He did
post it to linux-kernel, and perhaps even your ideas are inspired by
his work, I don't know. :-)

