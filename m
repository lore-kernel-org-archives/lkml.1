Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0BQXPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:15:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733Ab0BQXPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:15:09 -0500
Date: Thu, 18 Feb 2010 10:15:00 +1100
From: Neil Brown <neilb@suse.de>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100218101500.18c53517@notabene.brown>
In-Reply-To: <201002170338.47302.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
	<alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
	<20100217130103.3ca65ef3@notabene.brown>
	<201002170338.47302.volkerarmin@googlemail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 03:38:46 +0100
Volker Armin Hemmann <volkerarmin@googlemail.com> wrote:

> On Mittwoch 17 Februar 2010, Neil Brown wrote:
> 
> > I will not be removing 0.90 or auto-assemble from the kernel in the
> > foreseeable future.
> > None the less, I recommend weaning yourself from your dependence on it.
> > initramfs is the future, embrace it.
> > 
> > NeilBrown
> 
> a future that is worse than the present. For what reason?

Reason: some things are easier to implement and maintain in userspace.
Implementing them in the kernel would likely produce a worse products.

Worse than the present:  only if you refuse to embrace it and there-by
contribute to fixing/improving it.

NeilBrown

