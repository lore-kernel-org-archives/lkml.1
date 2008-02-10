Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYBJTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYBJTeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYBJTeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:34:01 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38751 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYBJTeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:34:00 -0500
Date: Sun, 10 Feb 2008 20:34:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
Message-ID: <20080210193406.GD13733@uranus.ravnborg.org>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <20080210163603.GB28201@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210163603.GB28201@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> so lets please all keep that goal in mind. This is not about "will we 
> have KGDB support or not", this is about "WHERE will we have KGDB 
> support", and i strongly support the notion that it should be in the 
> core kernel, where we can keep it clean, tidy and architecturally agile.

I think it was good to remind people that this is mostly generic
cross-architecture kgdb support and that x86 is just the first adaptor.

	Sam
