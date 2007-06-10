Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbXFJOfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbXFJOfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 10:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXFJOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 10:35:33 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35407 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbXFJOfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 10:35:32 -0400
Date: Sun, 10 Jun 2007 16:35:30 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: [patch-mm 07/23] Tick management: spread timer interrupt
Message-ID: <20070610143530.GA2138@rhlx01.hs-esslingen.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de> <20070610092446.625214085@inhelltoy.tec.linutronix.de> <20070610141617.GA15173@rhlx01.hs-esslingen.de> <1181485863.384.15.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181485863.384.15.camel@chaos>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 10, 2007 at 04:31:03PM +0200, Thomas Gleixner wrote:
> That's one time during setup, no hot path.

Urks, should have looked at actual file then instead of patch context only,
sorry!

Andreas Mohr
