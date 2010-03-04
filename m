Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0CDRB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:01:26 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49857 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab0CDRBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:01:22 -0500
Date: Fri, 5 Mar 2010 02:00:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 08/14] sh: Convert sh to use read/update_persistent_clock
Message-ID: <20100304170042.GA26618@linux-sh.org>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com> <1267675049-12337-2-git-send-email-johnstul@us.ibm.com> <1267675049-12337-3-git-send-email-johnstul@us.ibm.com> <1267675049-12337-4-git-send-email-johnstul@us.ibm.com> <1267675049-12337-5-git-send-email-johnstul@us.ibm.com> <1267675049-12337-6-git-send-email-johnstul@us.ibm.com> <1267675049-12337-7-git-send-email-johnstul@us.ibm.com> <1267675049-12337-8-git-send-email-johnstul@us.ibm.com> <1267675049-12337-9-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267675049-12337-9-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 07:57:23PM -0800, John Stultz wrote:
> This patch converts the sh architecture to use the generic
> read_persistent_clock and update_persistent_clock interfaces, reducing
> the amount of arch specific code we have to maintain, and allowing for
> further cleanups in the future.
> 
> I have not built or tested this patch, so help from arch maintainers
> would be appreciated.
> 
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Looks fine to me, I'll apply it, thanks.
