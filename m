Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZKIBt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZKIBt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 20:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZKIBt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 20:49:28 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38150 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbZKIBt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 20:49:28 -0500
Date: Mon, 9 Nov 2009 10:49:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-sh@vger.kernel.org
Subject: Re: [patch 13/16] sh: Replace old style lock initializer
Message-ID: <20091109014903.GA14254@linux-sh.org>
References: <20091106223547.784916750@linutronix.de> <20091106223806.933145642@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106223806.933145642@linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 10:42:05PM -0000, Thomas Gleixner wrote:
> SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: linux-sh@vger.kernel.org

Applied, thanks.
