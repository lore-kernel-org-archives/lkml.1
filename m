Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbYG1VZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbYG1VZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761337AbYG1VZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:25:20 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:16891 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761130AbYG1VZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:25:18 -0400
X-Trace: 50457372/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/81.1.72.79
X-SBRS: None
X-RemoteIP: 81.1.72.79
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAKTUjUhRAUhP/2dsb2JhbACBW65+
X-IronPort-AV: E=Sophos;i="4.31,267,1215385200"; 
   d="scan'208";a="50457372"
Subject: Re: drivers/sh/maple/maple.c compile error
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1217279595.6875.11.camel@localhost.localdomain>
References: <20080728202012.GD7713@cs181140183.pp.htv.fi>
	 <20080728204438.GC20019@linux-sh.org>
	 <1217278308.6875.3.camel@localhost.localdomain>
	 <20080728210121.GA27971@linux-sh.org>
	 <1217279595.6875.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 22:24:40 +0100
Message-Id: <1217280280.6875.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 22:13 +0100, Adrian McMenamin wrote:
> On Tue, 2008-07-29 at 06:01 +0900, Paul Mundt wrote:
> > On Mon, Jul 28, 2008 at 09:51:48PM +0100, Adrian McMenamin wrote:
> > > On Tue, 2008-07-29 at 05:44 +0900, Paul Mundt wrote:
> > > > On Mon, Jul 28, 2008 at 11:20:12PM +0300, Adrian Bunk wrote:
> > > > > Commit 306cfd630a4d121cf4e08b894d8b4c4cf106e57e
> > > > > (maple: tidy maple_driver code by removing redundant connect/disconnect)
> > > > > causes the following compile error:

> > 
> 
> http://lkml.org/lkml/2008/6/15/121 - removes the references from
> keyboard
> http://lkml.org/lkml/2008/6/15/122 - removes the references from the
> headers
> 

Ah I see what the issue is now. My apologies, it seems I made a patch
and for some reason never submitted it. But will do so now.

