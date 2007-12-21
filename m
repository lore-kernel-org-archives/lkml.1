Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbXLUCsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbXLUCsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXLUCsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:48:08 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:36793 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbXLUCsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:48:07 -0500
Date: Thu, 20 Dec 2007 21:48:05 -0500
From: Kyle McMartin <kmcmartin@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
Message-ID: <20071221024805.GB8535@fattire.cabal.ca>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 05:41:09PM -0800, Linus Torvalds wrote:
> The regression list keeps shrinking, so we're still on track for a full 
> 2.6.24 release in early January. Assuming we don't all overeat during the 
> holidays and nobody gets any work done. But we all know that the holidays 
> are really the time when we get away from the boring "real work", and can 
> spend 24/7 on kernel hacking instead, right?
> 

The patch-2.6.24-rc6.bz2 doesn't seem to apply to a pristine
linux-2.6.23 tree? I see this while updating Fedora:

+ '[' '!' -f /home/kyle/rpms/kernel/devel/patch-2.6.24-rc6.bz2 ']'
+ case "$patch" in
+ bunzip2
+ patch -p1 -F1 -s
1 out of 3 hunks FAILED -- saving rejects to file
drivers/video/mbx/reg_bits.h.rej
error: Bad exit status from /var/tmp/rpm-tmp.22316 (%prep)

cheers, Kyle
