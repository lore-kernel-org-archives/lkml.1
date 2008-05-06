Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbYEFQj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbYEFQj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYEFQjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:39:17 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:12477 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYEFQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:39:16 -0400
Subject: Re: [PATCH] clocksource: shift helper
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com>
	 <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Tue, 06 May 2008 09:39:14 -0700
Message-Id: <1210091954.17132.142.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 02:52 +0200, Thomas Gleixner wrote:
> On Thu, 1 May 2008, Daniel Walker wrote:
> 
> > This is a little helper I pulled from the mips tree.
> ... 
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> And who is the original author of this little helper in the MIPS tree?

commit 16b7b2ac0148e839da86af8747b6fa4aad43a9b7
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Daniel

