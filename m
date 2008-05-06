Return-Path: <linux-kernel-owner+w=401wt.eu-S933070AbYEFUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbYEFUeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbYEFUdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:33:40 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17379 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbYEFUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:33:39 -0400
Subject: Re: [PATCH] clocksource: shift helper
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com>
	 <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>
	 <1210091954.17132.142.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Tue, 06 May 2008 13:33:34 -0700
Message-Id: <1210106014.17132.172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 22:25 +0200, Thomas Gleixner wrote:
> On Tue, 6 May 2008, Daniel Walker wrote:
> > On Tue, 2008-05-06 at 02:52 +0200, Thomas Gleixner wrote:
> > > On Thu, 1 May 2008, Daniel Walker wrote:
> > > 
> > > > This is a little helper I pulled from the mips tree.
> > > ... 
> > > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > > 
> > > And who is the original author of this little helper in the MIPS tree?
> > 
> > commit 16b7b2ac0148e839da86af8747b6fa4aad43a9b7
> > Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Wouldn't it be appropriate to assign the authorship in the usual form
> i.e.:
> 
> From: Atsushi Nemoto <anemo@mba.ocn.ne.jp> 
> 
> on top of the patch and keep the original changelog message intact
> including the Signed-off-by of the author and Ralf ?
> 
> Aside of the broken S-O-B chain this is a blatant usurpation of
> somebody else's work.
> 

I took a function and modified it for my usage, which happens all the
time.

I'd be fine if Atsushi wants to sign off on the patch.

Daniel

