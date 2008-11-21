Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYKUC4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYKUC4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 21:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYKUCz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 21:55:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:42115 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYKUCzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 21:55:55 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <jeskpy7gnl.fsf@sykes.suse.de>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	 <jetzafiad4.fsf@sykes.suse.de> <1226353979.7530.8.camel@pasglop>
	 <jefxlzi2x0.fsf@sykes.suse.de> <1226360094.7530.18.camel@pasglop>
	 <je1vxji1br.fsf@sykes.suse.de> <1226368174.7530.47.camel@pasglop>
	 <jeskpy7gnl.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 13:55:11 +1100
Message-Id: <1227236111.7185.216.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 10:31 +0100, Andreas Schwab wrote:
> It looks like you are observing the same failure mode that I do.

The lockup when shutting down isn't happening for me anymore with recent
X (ubuntu intrepid) btw.

I haven't quite figured out what's up yet.

Cheers,
Ben.


