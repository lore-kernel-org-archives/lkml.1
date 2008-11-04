Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYKDWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYKDWv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbYKDWu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:50:29 -0500
Received: from kroah.org ([198.145.64.141]:38694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756428AbYKDWu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:50:27 -0500
Date: Tue, 4 Nov 2008 14:46:54 -0800
From: Greg KH <greg@kroah.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] NOHZ fixes for stable?
Message-ID: <20081104224654.GI3516@kroah.com>
References: <87ljwetbqr.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljwetbqr.fsf@denkblock.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 02:32:12PM +0200, Elias Oltmanns wrote:
> Hi all,
> 
> would these changes have a chance to go into a stable release?
> 
> fb02fbc1 (NOHZ: restart tick device from irq_enter())
> c4bd822e (NOHZ: fix thinko in the timer restart code path)

I would need Thomas to ack them to do so.

Thomas?

thanks,

greg k-h
