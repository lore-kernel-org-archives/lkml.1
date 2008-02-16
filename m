Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYBPUAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYBPUAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBPUAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:00:13 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:60460 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbYBPUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:00:11 -0500
X-Trace: 666841257/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAI7PtkdRAVlC/2dsb2JhbACBWapy
Subject: Re: Current git very broken on the Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linux-sh@vger.kernel.org
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       Magnus Damm <magnus.damm@gmail.com>, matsu@igel.co.jp,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203191304.6737.5.camel@localhost.localdomain>
References: <1203187080.6737.3.camel@localhost.localdomain>
	 <1203191304.6737.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 19:59:48 +0000
Message-Id: <1203191988.6737.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-16 at 19:48 +0000, Adrian McMenamin wrote:
> On Sat, 2008-02-16 at 18:38 +0000, Adrian McMenamin wrote:
> > Will seek to bisect this, but I have just updated my sources to the
> > latest git and it is not booting at all on the Dreamcast.
> > 

> adrian@bossclass:~/gdrom-dev$ git bisect good
> e036eaa681a17f71b64f6d9040fe605555623919 is first bad commit
> commit e036eaa681a17f71b64f6d9040fe605555623919
> Author: Magnus Damm <magnus.damm@gmail.com>
> Date:   Thu Feb 14 13:52:43 2008 +0900
> 

Reverting this commit *will* let my Dreamcast boot - can it be rolled
back pending further testing for a patch please?

Adrian

