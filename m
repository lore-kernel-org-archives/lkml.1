Return-Path: <linux-kernel-owner+w=401wt.eu-S1762406AbYEXVCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762406AbYEXVCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759391AbYEXVCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:02:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49574 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbYEXVCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:02:39 -0400
Date: Sat, 24 May 2008 23:03:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-ID: <20080524210318.GB3264@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <20080524125316.4b969936.akpm@linux-foundation.org> <48387736.9050004@goop.org> <20080524204610.GB3136@uranus.ravnborg.org> <48388112.6030003@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48388112.6030003@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 09:56:50PM +0100, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> >When we have one configuration for the kernel and not as today
> >where we have one configuration for each architecture (with a lot
> >of shared files) then it is already taken care of by my (updated) patch.
> 
> Yep.  But is a unified config something that someone is actively working 
> on, or a distant pipe dream?

Midway...
Roman implmented named choices and I have yet to try it out.

But I have a bit on my TODO list before I get there and
limited time (My day-time job is not Linux related).

	Sam
