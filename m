Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYKJJGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYKJJGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYKJJGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:06:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40882
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbYKJJGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:06:30 -0500
Date: Mon, 10 Nov 2008 01:06:29 -0800 (PST)
Message-Id: <20081110.010629.22603553.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, cloos@jhcloos.com, paul@burly.ondioline.org,
       torvalds@linux-foundation.org
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1226295985.7731.7.camel@pasglop>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	<wnN9HICUAgP.A._d.f5zFJB@chimera>
	<1226295985.7731.7.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 10 Nov 2008 16:46:25 +1100

> David, would you mind testing on your machine ? It's the one that shows
> the biggest performance improvement, and I would like to know how much
> it is affected by that patch. As long as the "worst case" performance
> is still reasonable, I'm ok to take the hit if the improvement for you
> is still significant.

I will test this out at the very next opportunity.

