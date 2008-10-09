Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbYJIQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbYJIQ2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYJIQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:28:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43840 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbYJIQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:28:27 -0400
Date: Thu, 9 Oct 2008 17:28:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@Opfer-Online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: 2.6.27-rc8 regression on arm: kernel will no longer boot on Sharp Zaurus c-3000
Message-ID: <20081009162807.GC4697@flint.arm.linux.org.uk>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz> <1223553647.3194.8.camel@hammer.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223553647.3194.8.camel@hammer.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 02:00:46PM +0200, Stanislav Brabec wrote:
> Pavel Machek wrote:
> > ...unfortunately, its kind of hard to debug, as I'm testing kernels
> > using kexec and only see messages late in boot. 2.6.26 works ok.
> 
> Lost patch:
> http://lists.arm.linux.org.uk/lurker/message/20081007.113509.c17e1e65.en.html
> 
> OT: 2.6.26 does not work OK. You need I2C init patch.

... and now queued for Linus.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
