Return-Path: <linux-kernel-owner+w=401wt.eu-S1764027AbXEUSAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764027AbXEUSAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbXEUSAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:00:09 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34277 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798AbXEUSAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:00:07 -0400
Date: Mon, 21 May 2007 10:57:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Darren Hart <dvhltc@us.ibm.com>,
       Andrew Morton <akpm@osdl.org>, Stable Team <stable@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [stable] [PATCH] Ignore bogus ACPI info for offline CPUs
Message-ID: <20070521175713.GH3429@sequoia.sous-sol.org>
References: <1179584570.12981.123.camel@chaos> <200705210947.35350.dvhltc@us.ibm.com> <20070521170815.GE3429@sequoia.sous-sol.org> <1179768728.12708.31.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179768728.12708.31.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> The irq 9 issue is a separate problem and only surfaces on some boxen,
> but it's not related to this patch. It's related to maxcpus=1 as well.

Thanks for confirming, just was double checking the two issues were
indeed separate.

thanks,
-chris
