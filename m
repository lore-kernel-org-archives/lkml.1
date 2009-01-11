Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZAKIFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZAKIFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZAKIFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:05:00 -0500
Received: from 1wt.eu ([62.212.114.60]:1409 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZAKIE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:04:59 -0500
Date: Sun, 11 Jan 2009 09:04:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc1
Message-ID: <20090111080420.GI5038@1wt.eu>
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 04:13:02PM -0800, Linus Torvalds wrote:
> But what perhaps stands out more is that we merged two whole new 
> filesystems - both btrfs and squashfs got merged. Even if they look pretty 
> "small" in that relentless onslaught of drivers.

Wow. I think that a lot of distro packagers who've been used to add
the squashfs patch to their kernels for something like 5 years will
applaud ! (I'm not dismissing btrfs, I've just not used it yet).

Cheers,
Willy

