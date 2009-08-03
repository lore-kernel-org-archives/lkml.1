Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZHCJW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZHCJW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZHCJW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:22:58 -0400
Received: from cmpxchg.org ([85.214.51.133]:53805 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZHCJW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:22:58 -0400
Date: Mon, 3 Aug 2009 11:20:29 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13813] Hangups in n_tty_read()
Message-ID: <20090803092029.GA2163@cmpxchg.org>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.xaD.RdgdKB@chimera> <c62985530908021815s547ac3aavb0d7a70c683ae79b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530908021815s547ac3aavb0d7a70c683ae79b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 03:15:10AM +0200, Frédéric Weisbecker wrote:
> 2009/8/2 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13813
> > Subject         : Hangups in n_tty_read()
> > Submitter       : Johannes Weiner <hannes@cmpxchg.org>
> > Date            : 2009-07-16 18:48 (18 days old)
> > References      : http://marc.info/?l=linux-kernel&m=124777019920579&w=4
> 
> 
> Johannes,
> 
> Does it still happen with latest mainline?
> Also, could you send us your .config ?

I wanted to wait until confirming this as this bug could take a while
to trigger.

But v2.6.31-rc4-405-gb592972 seems to be okay, I have it running
stable for several days now.

Thanks,
	Hannes
