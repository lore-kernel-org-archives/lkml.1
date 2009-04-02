Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZDBMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZDBMdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZDBMdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:33:00 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:40112 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZDBMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:33:00 -0400
Date: Thu, 2 Apr 2009 14:31:47 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [patch 12/18] cris: convert obsolete hw_interrupt_type to
	struct irq_chip
Message-ID: <20090402123147.GS31562@axis.com>
References: <20090311003204.592133594@linutronix.de> <20090311003236.704145797@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311003236.704145797@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 01:46:11AM +0100, Thomas Gleixner wrote:
> Impact: cleanup
> 
> Convert the last remaining users to struct irq_chip.

Thanks, adding it to the CRIS tree.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Mikael Starvik <starvik@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
