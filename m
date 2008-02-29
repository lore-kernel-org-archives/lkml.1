Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbYB2Psa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbYB2Psa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbYB2PsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:48:02 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53475 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbYB2PsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:48:00 -0500
Date: Fri, 29 Feb 2008 10:43:03 -0500
From: Jeff Dike <jdike@addtoit.com>
To: gorcunov@gmail.com
Cc: rth@twiddle.net, chris@zankel.net, linuxppc-dev@ozlabs.org,
       paulus@samba.org, dhowells@redhat.com, zippel@linux-m68k.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: [RFC 08/10] um: dyn/uml.lds.S cleanup - use PAGE_SIZE macro
Message-ID: <20080229154303.GC5886@c2.user-mode-linux.org>
References: <20080227205831.150784453@gmail.com> <20080227210004.189002678@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227210004.189002678@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:58:39PM +0300, gorcunov@gmail.com wrote:
> This patch includes page.h header into liker scripts that
> allow us to use PAGE_SIZE macro instead of numeric constant.
> 
> To be able to include page.h into linker scripts page.h is
> needed for some modification - i.e. we need to use __ASSEMBLY__
> and _AC macro
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Needed some fixing, but it's OK.  I'll forward it on.

       	    	    	Jeff

-- 
Work email - jdike at linux dot intel dot com
