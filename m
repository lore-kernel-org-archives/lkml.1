Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbYGOBwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbYGOBwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYGOBwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:52:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45061
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbYGOBwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:52:08 -0400
Date: Mon, 14 Jul 2008 18:52:07 -0700 (PDT)
Message-Id: <20080714.185207.203328391.davem@davemloft.net>
To: david@lang.hm
Cc: torvalds@linux-foundation.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
References: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
	<alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
	<alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: david@lang.hm
Date: Mon, 14 Jul 2008 17:51:37 -0700 (PDT)

> I agree with this, but the proponents of the seperate firmware are listing 
> the fact that the firmware doesn't tie up ram as one of the big reasons 
> for making the change.

Exactly.

Otherwise these firmware changes are utterly pointless.
