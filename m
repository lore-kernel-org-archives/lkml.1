Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXERBTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXERBTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 21:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbXERBTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 21:19:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:49675 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXERBTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 21:19:12 -0400
Subject: Re: radeonfb and X800 cards
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Daniel Drake <dsd@gentoo.org>, linux list <linux-kernel@vger.kernel.org>,
       Jimmy.Jazz@gmx.net
In-Reply-To: <20070517195958.GA6489@dreamland.darkstar.lan>
References: <464BB43D.2020407@gentoo.org>
	 <1179367164.32247.256.camel@localhost.localdomain>
	 <20070517195958.GA6489@dreamland.darkstar.lan>
Content-Type: text/plain
Date: Fri, 18 May 2007 11:19:00 +1000
Message-Id: <1179451140.32247.326.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This is what I'm using here, it's still the same old patch (Solomon's
> plus my stuff). I think I can coordinate with Jimmy.Jazz@gmx.net to
> create an incremental patch to fix radeonfb on his hardware (provided
> that this mega-patch is suitable as baseline that is).

Yes, I would very much appreciate if you guys managed to turn that into
some incremental patch serie. That would make it much easier for me to
review properly and track down possible regressions in fact.

Ben.


