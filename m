Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbYBEB2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbYBEB2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYBEB2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:28:03 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44100 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732AbYBEB2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:28:02 -0500
Subject: Re: Commit f06e4ec breaks vmware
From: Zachary Amsden <zach@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name, Glauber de Oliveira Costa <gcosta@redhat.com>
In-Reply-To: <20080204153631.GA30943@elte.hu>
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
	 <20080204115144.GA17850@elte.hu>
	 <b6a2187b0802040601s76222435t306aef2059cbbb2b@mail.gmail.com>
	 <20080204145311.GB13154@elte.hu>
	 <b6a2187b0802040730y44580594i56b26ed0fcb8292e@mail.gmail.com>
	 <20080204153631.GA30943@elte.hu>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 17:31:46 -0800
Message-Id: <1202175106.28740.4.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 16:36 +0100, Ingo Molnar wrote:
> * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> 
> > On Feb 4, 2008 10:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > > > commit 8d947344c47a40626730bb80d136d8daac9f2060
> > > > Author: Glauber de Oliveira Costa <gcosta@redhat.com>
> > > > Date:   Wed Jan 30 13:31:12 2008 +0100
> > > >
> > > >     x86: change write_idt_entry signature
> > >
> > > does the patch below ontop of x86.git#mm fix this?
> > 
> > 
> > > 32-bit or 64-bit guest kernel?
> > 
> > 32-bit.
> > 
> > Yep, this fixed the problem.
> 
> great! I've added:
> 
>    Tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
> 
> to the commit message as well, if you dont mind. Full patch is below.

Acked-by: Zachary Amsden <zach@vmware.com>

Thanks, Ingo!

