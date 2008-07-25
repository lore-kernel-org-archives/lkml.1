Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYGYHxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYGYHxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYGYHxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:53:30 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:20735 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYGYHxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:53:30 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-164.messagelabs.com!1216972408!10857159!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 25 Jul 2008 09:53:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <david-b@pacbell.net>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.26-git] genirq:  better warning on irqchip->set_type() failure
Message-ID: <20080725075324.GB24021@digi.com>
References: <200807241750.25507.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807241750.25507.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 25 Jul 2008 07:53:24.0893 (UTC) FILETIME=[8431F4D0:01C8EE2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> While I'm glad to finally see the hole fixed whereby passing an
> invalid IRQ trigger type to request_irq() would be ignored, the
> current diagnostic isn't quite useful.  Fixed by also listing
> the trigger type which was rejected.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
 
Best regards and thanks
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
