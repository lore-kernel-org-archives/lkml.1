Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbXHBT45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbXHBT45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbXHBT4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:56:50 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43556 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350AbXHBT4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:56:49 -0400
Date: Thu, 2 Aug 2007 15:56:46 -0400
Message-Id: <200708021956.l72JukXE014718@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Jon Mansey <jon@mansey.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unionfs and snmpd kernle bug report 
In-reply-to: Your message of "Thu, 02 Aug 2007 12:18:32 PDT."
             <46B22E08.80102@mansey.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <46B22E08.80102@mansey.com>, Jon Mansey writes:
> kernel BUG at
> /home/user/linux-modules-extra-2.6-2.6.18/debian/build/build_i386_none_686-bigmem_unionfs/build/commonfops.c:189! 

Jon, please send such reports to the unionfs mailing list directly (see
http://unionfs.filesystems.org/), esp. when it's for unionfs 2.x running on
older kernels such as 2.6.18.  There's no need to bother lkml with such a
report.

I'll email you privately more info on what you need to do to report this
properly.

Thanks,
Erez.
