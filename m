Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZKLLhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZKLLhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZKLLhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:37:35 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:54238 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZKLLhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:37:34 -0500
Date: Thu, 12 Nov 2009 12:37:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Linus Walleij <linus.walleij@stericsson.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/3] Provide generic function to calc mult/shift
	factors for clocks
Message-ID: <20091112113727.GA8745@linux-mips.org>
References: <20091111134018.393422332@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111134018.393422332@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 02:05:19PM -0000, Thomas Gleixner wrote:

> The MIPS tree has functions to calculate the mult/shift factors for
> clock events and clock sources. ARM needs such functions as well. 
> 
> This patch set provides a generic function which replaces the MIPS
> implementation.

Looks good to me, feel free to throw in my Ack-by.  I suggest you merge the
MIPS part of the series through your tree.

  Ralf
