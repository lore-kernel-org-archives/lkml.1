Return-Path: <linux-kernel-owner+w=401wt.eu-S1750774AbXBHSbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbXBHSbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXBHSbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:31:47 -0500
Received: from raven.upol.cz ([158.194.120.4]:54945 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXBHSbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:31:46 -0500
Date: Thu, 8 Feb 2007 19:39:54 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: + search-a-little-harder-for-mkimage.patch
Message-ID: <20070208183954.GW22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org> <20070207203047.51a95ad0.akpm@linux-foundation.org> <20070208052439.GL22699@flower.upol.cz> <20070207211921.1f0220a4.akpm@linux-foundation.org> <20070208055832.GN22699@flower.upol.cz> <Pine.LNX.4.64.0702081735440.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702081735440.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 05:38:28PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Thu, 8 Feb 2007, Oleg Verych wrote:
> 
> > BTW, Debian shell policy is to be bashizms-clear. Purpose -- to have
> > compatibility with any `sh'. Shall we?
> 
> Wrong.
> 
> http://www.debian.org/doc/debian-policy/ch-files.html#s-scripts
"""
   You may wish to restrict your script to POSIX features when possible
   so that it may use /bin/sh as its interpreter. If your script works
   with dash (originally called ash), it's probably POSIX compliant, but
   if you are in doubt, use /bin/bash.
"""
I think, it's OK to start with ;)      

> bye, Roman

____
