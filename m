Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYKKJbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYKKJbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYKKJbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:31:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:54787 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYKKJbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:31:31 -0500
From: Andreas Schwab <schwab@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	<wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	<jetzafiad4.fsf@sykes.suse.de> <1226353979.7530.8.camel@pasglop>
	<jefxlzi2x0.fsf@sykes.suse.de> <1226360094.7530.18.camel@pasglop>
	<je1vxji1br.fsf@sykes.suse.de> <1226368174.7530.47.camel@pasglop>
X-Yow: By MEER biz doo SCHOIN..
Date: Tue, 11 Nov 2008 10:31:26 +0100
In-Reply-To: <1226368174.7530.47.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Tue, 11 Nov 2008 12:49:34 +1100")
Message-ID: <jeskpy7gnl.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like you are observing the same failure mode that I do.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
