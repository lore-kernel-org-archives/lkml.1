Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbXEFUFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbXEFUFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXEFUFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:05:15 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4108 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbXEFUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:05:14 -0400
Date: Sun, 6 May 2007 21:05:04 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ryan Ordway <ryan.ordway@oregonstate.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] mixing 8250/16550 and AT91 serial ports causes oops
Message-ID: <20070506200504.GD21158@flint.arm.linux.org.uk>
Mail-Followup-To: Ryan Ordway <ryan.ordway@oregonstate.edu>,
	linux-kernel@vger.kernel.org
References: <20070506190039.GA24881@martell.zuzino.mipt.ru> <C2637ADD.CD26%ryan.ordway@oregonstate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2637ADD.CD26%ryan.ordway@oregonstate.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 12:30:21PM -0700, Ryan Ordway wrote:
> I tracked down my oops. It looks to be a problem with mixing 8250/16550
> serial ports and the AT91 ports on the Atmel AT91SAM9260-EK board. Here is
> the oops:

I meant linux-arm-kernel, not linux-kernel as I was trying to suggest
on linux-arm.  And I also strongly recommend that you try what I
suggested in my first reply to you on linux-arm.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
