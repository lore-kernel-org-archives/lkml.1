Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYD0Abg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYD0Abg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYD0Aba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:31:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58069
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbYD0Ab3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:31:29 -0400
Date: Sat, 26 Apr 2008 17:31:29 -0700 (PDT)
Message-Id: <20080426.173129.232382024.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: bunk@kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com,
       mchehab@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: If you want me to quit I will quit
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
References: <20080426084420.8e61c379.akpm@linux-foundation.org>
	<20080426171604.GN2252@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Apr 2008 10:31:36 -0700 (PDT)

> And once you've publicized them, you don't know who has that tree, so just 
> from a sanity and debugging standpoint, you should try to avoid mucking 
> with already-public versions. If you made a mistake, add a patch on top to 
> fix it (and announce the new state), but generally try to not "hide" the 
> fact that the state has changed.

I didn't rebase at all this past cycle for networking, and it
helped the people downstream from me _A LOT_.

Anyone who rebases frequently, like I used to, is an idiot, like
me. :-)

