Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYFBKN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYFBKN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYFBKNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:13:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbYFBKNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:13:49 -0400
Date: Mon, 2 Jun 2008 12:13:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xen: fix compilation when CONFIG_PM_SLEEP is disabled
Message-ID: <20080602101323.GC7459@elte.hu>
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost> <20080529073150.GA19744@elte.hu> <483E630B.5090006@goop.org> <20080529172436.70598587.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529172436.70598587.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 29 May 2008 09:02:19 +0100 Jeremy Fitzhardinge wrote:
> 
> > Xen save/restore depends on CONFIG_PM_SLEEP being set for device_power_up/down.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Ack.  Thanks.

applied to tip/x86/xen. Thanks,

	Ingo
