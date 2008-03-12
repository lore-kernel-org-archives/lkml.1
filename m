Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbYCLA4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbYCLA4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYCLA4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:56:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45825
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbYCLA4S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:56:18 -0400
Date: Tue, 11 Mar 2008 17:56:25 -0700 (PDT)
Message-Id: <20080311.175625.193682131.davem@davemloft.net>
To: tglx@linutronix.de
Cc: ilpo.jarvinen@helsinki.fi, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Treason uncloaked spams syslog with latest git
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0803111440040.3781@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0803102046420.3781@apollo.tec.linutronix.de>
	<Pine.LNX.4.64.0803111138360.5423@kivilampi-30.cs.helsinki.fi>
	<alpine.LFD.1.00.0803111440040.3781@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 11 Mar 2008 14:59:53 +0100 (CET)

> On Tue, 11 Mar 2008, Ilpo Järvinen wrote:
> > > http://www.tglx.de/~tglx/treason.cap
> > > 
> > > That's on -rc5
> > 
> > Thanks, I think I found the reason. Does the patch below fix it...
> 
> Yes, it does.
> 
> > message suggests, we had just sent something past it without
> > a permission to do so).
> > 
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> 
> Tested-by: Thomas Gleixner <tglx@linutronix.de>

Patch applied, thanks everyone.
