Return-Path: <linux-kernel-owner+w=401wt.eu-S934359AbZLFWXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359AbZLFWXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 17:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934317AbZLFWXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 17:23:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55536 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934309AbZLFWXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 17:23:41 -0500
Date: Sun, 6 Dec 2009 23:23:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] aim7 scalability issue on 4 socket machine
Message-ID: <20091206222336.GA14305@elf.ucw.cz>
References: <1253180411.8497.1.camel@twins>
 <Pine.LNX.4.64.0909171122180.25864@sister.anvils>
 <1253239339.2606.40.camel@ymzhang>
 <20090917195909.3a00ef83.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
 <20090918000542.268934e1.akpm@linux-foundation.org>
 <20091206200833.GA2357@elf.ucw.cz>
 <20091206201136.GZ18989@one.firstfloor.org>
 <20091206211105.GA13917@elf.ucw.cz>
 <20091206221734.GA22414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206221734.GA22414@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Deal with specifics on a case-by-case basis, and if you don't really
> care about this, then why dig up a many-month old thread?

Digging it was a mistake, I was working on wrong machine. Sorry.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
