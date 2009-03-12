Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZCLVAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZCLVAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZCLVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:00:20 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34953 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZCLVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:00:19 -0400
Date: Thu, 12 Mar 2009 22:02:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, geert@linux-m68k.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090312210216.GB14205@uranus.ravnborg.org>
References: <200903120437.03837.rob@landley.net> <20090312095854.GA9398@uranus.ravnborg.org> <200903121503.37195.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903121503.37195.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> And, yes, I can confirm the m68k include/asm/unistd.h from linux-next actually 
> has contents, thanks to commit 646652bded41f4c3bd375b4e03a25b42da93f40b
> 
> Anyway, here's hoping the fix makes it into 2.6.29.

Why not telling the m68k maintainer that you think it should go into 2.6.29?

As it stand now we will ikely see another mail from you "I already said so"
when we ship it broken but you did not care to tell relevant people.

grep -C 5 -i m68k MAINTAINES revelas this:
M68K ARCHITECTURE
P:      Geert Uytterhoeven
M:      geert@linux-m68k.org
P:      Roman Zippel
M:      zippel@linux-m68k.org
L:      linux-m68k@lists.linux-m68k.org
W:      http://www.linux-m68k.org/
W:      http://linux-m68k-cvs.ubb.ca/
S:      Maintained


	Sam
