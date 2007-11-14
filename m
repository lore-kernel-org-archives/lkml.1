Return-Path: <linux-kernel-owner+w=401wt.eu-S1764219AbXKNT4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764219AbXKNT4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbXKNT4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:56:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46544
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbXKNT4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:56:04 -0500
Date: Wed, 14 Nov 2007 11:56:01 -0800 (PST)
Message-Id: <20071114.115601.00715073.davem@davemloft.net>
To: mingo@elte.hu
Cc: rdunlap@xenotime.net, akpm@linux-foundation.org, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071114140847.GA11489@elte.hu>
References: <20071113134029.GA30978@elte.hu>
	<20071113085514.3414aa52.rdunlap@xenotime.net>
	<20071114140847.GA11489@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Nov 2007 15:08:47 +0100

> In fact this thread is the very example: David points out that on netdev 
> some of those bugs were already discussed and resolved. Had it been all 
> on lkml we'd all be aware of it.

That's a rediculious argument.

One other reason these bugs are resolved, is that the networking
developers only need to subscribe to netdev and not have to listen to
all the noise on lkml.

People who want to manage bugs know what list to look on and
contact about problems.

Dumping even more crap on lkml is not the answer.
