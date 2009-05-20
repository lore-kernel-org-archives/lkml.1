Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZETTiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZETTiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZETTiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 15:38:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33745
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbZETTiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 15:38:16 -0400
Date: Wed, 20 May 2009 12:38:14 -0700 (PDT)
Message-Id: <20090520.123814.11278413.davem@davemloft.net>
To: keil@b1-systems.de
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design
 board to hfcmulti
From: David Miller <davem@davemloft.net>
In-Reply-To: <200905201112.22062.keil@b1-systems.de>
References: <20090519.121116.52530205.davem@davemloft.net>
	<1242789181.3147.18.camel@localhost.localdomain>
	<200905201112.22062.keil@b1-systems.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <keil@b1-systems.de>
Date: Wed, 20 May 2009 11:12:21 +0200

> Yes, you are right, I queued it for linux-next because I was remembering that 
> somebody did suggest this in the past, but this was not really a good idea.
> I will setup a new merge tree based on net-2.6-next  (or better net-2.6) ?

For this stuff, net-next-2.6 would be the most appropriate.
