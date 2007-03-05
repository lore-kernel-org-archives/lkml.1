Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbXCEAEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbXCEAEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXCEAEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:04:21 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49853 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550AbXCEAET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:04:19 -0500
Date: Mon, 5 Mar 2007 01:04:21 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Message-ID: <20070305000421.GF3441@stusta.de>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070226220152.GA29575@stusta.de> <20070228211318.GB4301@mellanox.co.il> <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 11:45:35AM +0800, Jeff Chua wrote:
> On 3/1/07, Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> >with 2.6.20, pressing Fn/F4 generates an ACPI event and triggers suspend 
> >to RAM.
> >
> >On 2.6.21-rc2, after resume (when the box is accessible from network),
> >pressing Fn/F4 again does not seem to have any effect.
> 
> I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
> from RAM, can't suspend to disk. It is possible to revert all the
> changes to ACPI and test it?

This is with CONFIG_KVM=n?

> Jeff.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

