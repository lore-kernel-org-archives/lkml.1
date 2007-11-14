Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbXKNBLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbXKNBLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761011AbXKNBKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:10:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34759
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760084AbXKNBKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:10:52 -0500
Date: Tue, 13 Nov 2007 17:10:51 -0800 (PST)
Message-Id: <20071113.171051.199524749.davem@davemloft.net>
To: liml@rtr.ca
Cc: bunk@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       protasnb@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <4739EA83.5040006@rtr.ca>
References: <4739E3D0.10201@rtr.ca>
	<20071113181228.GF4250@stusta.de>
	<4739EA83.5040006@rtr.ca>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <liml@rtr.ca>
Date: Tue, 13 Nov 2007 13:18:43 -0500

> Mind you, no arguing that this is effective when that poor bloke has
> a day free to download the git-tree and build/reboot a dozen times.

Like the internet, this time spent is beneficial because it's
pushing the work out to the end nodes.  In fact git bisect is
an awesome example of the end node principle in action for
software development and QA.

For the end-user wanting their bug fixed and the developer it's a win
win situation because the reporter is actually able to do something
proactive which will help get the bug they want fixed faster.

So I don't agree with framing this person as a "poor bloke".  Our
testers are more empowered than ever to lead the process towards a
fix.
