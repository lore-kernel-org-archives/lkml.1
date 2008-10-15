Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYJOLj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYJOLj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYJOLjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:39:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41693 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYJOLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:39:41 -0400
Date: Wed, 15 Oct 2008 12:39:23 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@Opfer-Online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: 2.6.27-rc8 regression on arm: kernel will no longer boot on Sharp Zaurus c-3000
Message-ID: <20081015113923.GA21756@flint.arm.linux.org.uk>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz> <1223553647.3194.8.camel@hammer.suse.cz> <20081009142351.GA4697@flint.arm.linux.org.uk> <20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 12:17:47PM +0200, Pavel Machek wrote:
> Thanks for the effort, but it looks like it did not make it, right?

Correct - Linus was unpredictable and released 2.6.27 that evening,
four days early giving me no time to push the fix to him.

However, it's gone in as part of the first ARM merge, so should be in
-rc1.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
