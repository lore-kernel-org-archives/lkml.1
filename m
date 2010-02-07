Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0BGE6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 23:58:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab0BGE6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 23:58:47 -0500
Date: Sat, 6 Feb 2010 23:58:44 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
Message-ID: <20100207045844.GS24051@bombadil.infradead.org>
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain> <4B6E4793.3010201@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6E4793.3010201@teksavvy.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 11:54:43PM -0500, Mark Lord wrote:
> I just wish the GNU tar folk had the sense to combine -z and -j
> into a single flag.
>

Shouldn't be needed anymore...

kyle@ihatethathostname ~/rpms/kernel/tarballs $ tar --version
tar (GNU tar) 1.22
kyle@ihatethathostname ~/rpms/kernel/tarballs $ tar xvf
linux-2.6.31.tar.bz2 | head -n 2
linux-2.6.31/
linux-2.6.31/.gitignore

regards, Kyle
