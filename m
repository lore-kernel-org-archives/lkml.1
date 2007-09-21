Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXIUHT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXIUHT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 03:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXIUHTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 03:19:20 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:27582 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbXIUHTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 03:19:19 -0400
X-Trace: 605904930-mk-filter-1.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEIN80ZRAUxC/2dsb2JhbACBWg
Subject: Re: Fwd: [PATCH 0/3] Add Maple bus support for the SEGA Dreamcast
	- repost
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070921070057.GB7053@linux-sh.org>
References: <8b67d60709200429y2118d943rcddf2b0fa31a5502@mail.gmail.com>
	 <20070921070057.GB7053@linux-sh.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 08:19:00 +0100
Message-Id: <1190359140.6009.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 16:00 +0900, Paul Mundt wrote:
> On Thu, Sep 20, 2007 at 12:29:40PM +0100, Adrian McMenamin wrote:
> > The Maple bus is SEGA's proprietary serial bus for peripherals
> > (keyboard, mouse, controller etc). The bus is capable of some
> > (limited) hotplugging and operates at up to 2 M/bits.
> > 
> I've applied this and the header changes with a bit of tidying. Dmitry can
> merge the keyboard driver in the input tree at any time, the Kconfig
> dependency will just prevent it from showing up until the SH tree has
> merged.
> 
Thanks
