Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbYHFTwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbYHFTwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYHFTv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:51:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33921 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYHFTv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:51:56 -0400
Date: Wed, 6 Aug 2008 20:51:32 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080806195132.GC29891@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	linux arch <linux-arch@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <200808051418.05324.rusty@rustcorp.com.au> <20080805204548.GD5464@uranus.ravnborg.org> <20080805220615.GC18607@flint.arm.linux.org.uk> <20080806192126.GA29891@flint.arm.linux.org.uk> <20080806192842.GB17227@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806192842.GB17227@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 09:28:42PM +0200, Sam Ravnborg wrote:
> Our mails crossed. I will fix kbuild asap so you do not need to revert.

Have crossed again, sorry.  If you can get a fix for the asm/errno.h
thing to Linus ASAP, that'd be great.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
