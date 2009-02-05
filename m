Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZBEP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZBEP5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZBEP5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:57:03 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55846 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbZBEP5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:57:03 -0500
X-Greylist: delayed 1750 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 10:57:03 EST
Date: Thu, 5 Feb 2009 10:57:00 -0500
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, uClinux list <uclinux-dev@uclinux.org>
Subject: Re: Fix support for console port other than ttyS0 on mcf.c
Message-ID: <20090205155700.GO26064@csclub.uwaterloo.ca>
References: <20090204201518.GH26064@csclub.uwaterloo.ca> <20090204202009.GI26064@csclub.uwaterloo.ca> <Pine.LNX.4.64.0902042200340.25136@anakin> <20090205152751.GL26064@csclub.uwaterloo.ca> <Pine.LNX.4.64.0902051652080.5127@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902051652080.5127@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 04:53:50PM +0100, Geert Uytterhoeven wrote:
> linux-m68k@lists.linux-m68k.org handles m68k (with MMU) only.
> uclinux-dev@uclinux.org handles m68knommu.

Oh.  I think I got confused by the fact the same arch/m68k/include is
used for both. so I looked up m68k in MAINTAINERS.

I will start bothering uclinux-dev@uclinux.org instead.

So by uclinux driver you meant m68knommu uclinux driver.  I was thinking
uclibc for some reason.

-- 
Len Sorensen
