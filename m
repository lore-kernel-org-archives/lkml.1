Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYJOJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYJOJmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYJOJmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:42:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:60472 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbYJOJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:42:01 -0400
Subject: Re: [git pull] Please pull from powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Robert Richter <robert.richter@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <200810151041.29069.arnd@arndb.de>
References: <1224033396.8157.386.camel@pasglop>
	 <20081015083516.GL23557@erda.amd.com>  <200810151041.29069.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 20:41:26 +1100
Message-Id: <1224063686.8157.449.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 10:41 +0200, Arnd Bergmann wrote:
> On Wednesday 15 October 2008, Robert Richter wrote:
> > there are still these OProfile patches for powerpc pending:
> > 
> > Carl Love (1):
> >       powerpc/cell/oprofile: fix mutex locking for spu-oprofile
> > 
> > Roel Kluin (1):
> >       powerpc/cell/oprofile: vma_map: fix test on overlay_tbl_offset
> > 
> > Can you or Paul send them upstream? You can pull from here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git powerpc-for-paul
> > 
> 
> The patch from Roel is already in there, with a slightly different
> subject line. The one from Carl is still missing.

I'll put it in my tree tomorrow, it will be in the second batch. For
lurkers, make sure that if you have a patch missing, it's resent and
shows up in patchwork. Some patches that missed the new patchwork
transition might have fallen off if paulus didn't pick them up before I
took over.

Cheers,
Ben.


