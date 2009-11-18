Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZKRBwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZKRBwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZKRBwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:52:46 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43060 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZKRBwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:52:45 -0500
Date: Wed, 18 Nov 2009 10:52:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-sh@vger.kernel.org
Subject: Re: [patch 05/13] sh: Fixup last users of irq_chip->typename
Message-ID: <20091118015205.GB3414@linux-sh.org>
References: <20091117224852.846805939@linutronix.de> <20091117224916.528768738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117224916.528768738@linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 10:50:45PM -0000, Thomas Gleixner wrote:
> The typename member of struct irq_chip was kept for migration purposes
> and is obsolete since more than 2 years. Fix up the leftovers.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: linux-sh@vger.kernel.org

Applied, thanks.
