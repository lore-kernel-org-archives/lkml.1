Return-Path: <linux-kernel-owner+w=401wt.eu-S968200AbXILQgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968200AbXILQgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765509AbXILQgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:36:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765595AbXILQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:35:59 -0400
Date: Wed, 12 Sep 2007 09:35:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       maxk@qualcomm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.23-rc6] i386 build breakage on current git
In-Reply-To: <46E81433.5070702@garzik.org>
Message-ID: <alpine.LFD.0.999.0709120935240.16478@woody.linux-foundation.org>
References: <46E81433.5070702@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Sep 2007, Jeff Garzik wrote:
>
> Platform i386 seems to be missing struct compat_timeval, which causes the i386
> allmodconfig build to break in current -git:

Well, not in "current" current -git.

IOW, the patch was pushed out minutes ago ;)

		Linus
