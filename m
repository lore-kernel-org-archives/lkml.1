Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYDNKA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYDNKA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYDNKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:00:22 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:47626 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751745AbYDNKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:00:20 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-6.tower-164.messagelabs.com!1208167219!8602098!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Mon, 14 Apr 2008 12:00:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080414100015.GA19304@digi.com>
References: <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com> <20080411103346.GC3185@local> <20080411110358.GC19973@digi.com> <20080411111703.GD3185@local> <20080411112543.GA23221@digi.com> <20080412131646.GF9669@flint.arm.linux.org.uk> <20080414074858.GA22694@digi.com> <20080414093714.GD1540@flint.arm.linux.org.uk> <20080414095445.GA19413@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080414095445.GA19413@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Apr 2008 10:00:16.0278 (UTC) FILETIME=[56CCA360:01C89E16]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15848.006
X-TM-AS-Result: No--9.797000-8.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> This is completly independant of the inclusion of drivers/uio/Kconfig in
> arch/arm/Kconfig.  I will send a patch for that.
BTW: I just found

	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core/uio-arch-arm-kconfig-make-uio-available-on-arm-architecture.patch

So obviously gkh looks for that issue.  In my eyes it should better go
via rmk, but it doesn't really matter for me.  Should I still send a
patch to the patch system?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
