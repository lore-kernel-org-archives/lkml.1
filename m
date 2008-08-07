Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYHGLt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYHGLt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 07:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYHGJ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 05:26:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38767 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYHGJ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 05:26:20 -0400
Date: Thu, 7 Aug 2008 10:18:10 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Denis ChengRq <crquan@gmail.com>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] kbuild fixes
Message-ID: <20080807091810.GB14078@flint.arm.linux.org.uk>
References: <20080806202738.GA20066@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806202738.GA20066@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:27:38PM +0200, Sam Ravnborg wrote:
> Please pull following kbuild related fixes.
> 
> o Fix "make O=..." builds for arm
> o update to for newer cscope
> o patch-kernel fix (but I doubt it has many uses)
> o small Kconfig clean-up

Note that I've also merged your tree into mine, so I can test my
further asm-arm renames with something that works.  So far, it's
looking good, thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
