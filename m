Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZECIai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZECIai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 04:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZECIa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 04:30:27 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34574 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZECIa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 04:30:26 -0400
Date: Sun, 3 May 2009 17:24:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 02/11] sh: remove obsolete no_irq_type
Message-ID: <20090503082459.GB23434@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20090502195607.539955644@linutronix.de> <20090502195926.117909052@linutronix.de> <20090502195607.539955644@linutronix.de> <20090502195925.263615612@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502195926.117909052@linutronix.de> <20090502195925.263615612@linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 08:00:44PM -0000, Thomas Gleixner wrote:
> Impact: cleanup
> 
> convert the last remaining users to no_irq_chip
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Paul Mundt <lethal@linux-sh.org>

On Sat, May 02, 2009 at 08:01:20PM -0000, Thomas Gleixner wrote:
> Impact: cleanup
> 
> Convert the last remaining users to struct irq_chip and remove the
> define.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Paul Mundt <lethal@linux-sh.org>

Both applied, thanks.
