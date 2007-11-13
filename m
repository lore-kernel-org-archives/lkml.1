Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbXKMLtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbXKMLtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbXKMLti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:49:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757750AbXKMLtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:49:33 -0500
Date: Tue, 13 Nov 2007 03:49:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: protasnb@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113034916.2556edd7.akpm@linux-foundation.org>
In-Reply-To: <20071113.033946.114918709.davem@davemloft.net>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	<20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<20071113.033946.114918709.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 03:39:46 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 13 Nov 2007 03:15:53 -0800
> 
> > > NETWORKING===========================================================
> > > 
> > > RTNLGRP_ND_USEROPT does not report ifindex (IPv6)
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9349
> > > Kernel: 2.6.24+
> > 
> > No response from developers
> 
> That's funny, then how come there was a proper patch fix posted
> and it's now in my tree ready to go to Linus?
> 
> I think you like just saying "No response from developers" over and
> over again to make some of point about how developers are ignoring
> lots of bugs.  That's fine, but at least be accurate about it :-)

Do you believe that our response to bug reports is adequate?
