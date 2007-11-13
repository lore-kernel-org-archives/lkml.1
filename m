Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbXKMLj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbXKMLj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXKMLjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:39:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56951
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbXKMLjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:39:46 -0500
Date: Tue, 13 Nov 2007 03:39:46 -0800 (PST)
Message-Id: <20071113.033946.114918709.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: protasnb@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	<20071113031553.3c7b5c16.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Nov 2007 03:15:53 -0800

> > NETWORKING===========================================================
> > 
> > RTNLGRP_ND_USEROPT does not report ifindex (IPv6)
> > http://bugzilla.kernel.org/show_bug.cgi?id=9349
> > Kernel: 2.6.24+
> 
> No response from developers

That's funny, then how come there was a proper patch fix posted
and it's now in my tree ready to go to Linus?

I think you like just saying "No response from developers" over and
over again to make some of point about how developers are ignoring
lots of bugs.  That's fine, but at least be accurate about it :-)
