Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539Ab0AXX31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab0AXX31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229Ab0AXX30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:29:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53545 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0AXX30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:29:26 -0500
Date: Sun, 24 Jan 2010 23:29:12 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Soeren Sandmann <sandmann@daimi.au.dk>
Subject: Re: [Bug #14625] Commit d451564 breaks ARM
Message-ID: <20100124232912.GA10805@flint.arm.linux.org.uk>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.5sB.QbMXLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q60Z28d_9yH.A.5sB.QbMXLB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:22:52PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).

Fixed by 4ff1fa2.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
