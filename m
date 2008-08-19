Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYHSUPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYHSUPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYHSUOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:14:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57697
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbYHSUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:14:54 -0400
Date: Tue, 19 Aug 2008 13:14:54 -0700 (PDT)
Message-Id: <20080819.131454.223684377.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org>
References: <20080819.041706.261399060.davem@davemloft.net>
	<alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Aug 2008 10:03:07 -0700 (PDT)

> For example, those BT updates looked in no way like regression fixes. So 
> what the f*ck were they doing there? And why do you think all those driver 
> updates cannot cause new regressions? 

The BT bits were the only part I really considered borderline,
and I was going to push back on Marcel.

But to be honest, I haven't seen bluetooth updates from him
for such a long time I felt that being strict here would just
exacerbate the problem.

Guess I was wrong.
