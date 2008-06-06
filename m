Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYFFMMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYFFMMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYFFMMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:12:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54689 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYFFMMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:12:14 -0400
Date: Fri, 6 Jun 2008 13:05:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       rmh@aybabtu.com
Subject: Re: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports
	OLPC
Message-ID: <20080606110549.GA5396@elf.ucw.cz>
References: <20080605152914.6f4ca839@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605152914.6f4ca839@ephemeral>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-05 15:29:14, Andres Salomon wrote:
> Previously, one would have to specifically choose CONFIG_OLPC and
> CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
> work for distro kernels, so this patch allows one to choose

How do distros work on OLPC, anyway? It lacks normal BIOS, so you
can't really use GRUB, right?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
