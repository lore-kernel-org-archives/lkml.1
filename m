Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYBKRMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYBKRMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYBKRMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:12:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:64457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYBKRMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:12:24 -0500
Date: Mon, 11 Feb 2008 18:12:10 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] kgdb light, v7
Message-ID: <20080211171209.GA5062@ska.dandreoli.com>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080210222025.GA6646@elte.hu> <20080211154133.GA3292@ska.dandreoli.com> <47B07DEB.3090803@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B07DEB.3090803@siemens.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 05:55:07PM +0100, Jan Kiszka wrote:
> Domenico Andreoli wrote:
> > On Sun, Feb 10, 2008 at 11:20:26PM +0100, Ingo Molnar wrote:
> >> this is -v7 of the KGDB-light tree, which can be pulled from:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git
> > 
> > my git hangs on this..
> 
> Just booting? Or using the debugger? If the former: does switching KGDB
> off in the config solve it?

sorry, git pull was hanging. it looks somewhat related to the kernel
version (debian 2.6.24-3), rebooting did not cure it.

i had also many problems with ssh, many (but not all) were
hanging. moreover X was very sluggish, as well as the network.  now i
am back to debian 2.6.23-2 and everything works correctly. odd.

regards,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
