Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637Ab0ABJdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0ABJdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 04:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580Ab0ABJdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 04:33:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55063 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0ABJda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 04:33:30 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
       "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
       "Nayak, Rajendra" <rnayak@ti.com>
Date: Sat, 2 Jan 2010 15:02:55 +0530
Subject: RE: linux-next: origin tree build warnings
Thread-Topic: linux-next: origin tree build warnings
Thread-Index: AcqKhN3NP6rQ+O04To69lQQjTuvzSwBCNkAg
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C02E9494@dbde02.ent.ti.com>
References: <20100101114238.83108321.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0912311649070.3630@localhost.localdomain>
	<20100101122259.394d5b19.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0912311731130.3630@localhost.localdomain>
 <20100101125046.23103597.sfr@canb.auug.org.au>
In-Reply-To: <20100101125046.23103597.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,Linus,

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Friday, January 01, 2010 7:21 AM
> To: Linus Torvalds
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Thomas Gleixner; Samuel Ortiz; Tony
> Lindgren; Shilimkar, Santosh; Krishnamoorthy, Balaji T; Nayak, Rajendra
> Subject: Re: linux-next: origin tree build warnings
> 
> Hi Linus,
> 
> On Thu, 31 Dec 2009 17:32:11 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > On Fri, 1 Jan 2010, Stephen Rothwell wrote:
> > >
> > > I have built drivers/mfd/twl4030-irq.o the same way as before but after
> > > applying your patch and the warnings are fixed.  I do not have the
> > > hardware and so cannot do a runtime test.
> >
> > Ok, committed as "Reported-and-compile-tested-by:" you.
> 
> Thanks.
> 
> > Somebody should probably test it on real hardware, but I doubt the patch
> > makes anything worse, and it _probably_ makes things better.
> 
> With any luck :-)
Have tested this patch on OMAP3430 and works as expected. 

Regards,
Santosh

