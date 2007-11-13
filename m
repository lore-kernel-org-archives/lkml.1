Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbXKMF3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbXKMF3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXKMF32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:29:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbXKMF31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:29:27 -0500
Date: Mon, 12 Nov 2007 21:29:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, David <david@unsolicited.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
 startup
Message-Id: <20071112212905.abdf6078.akpm@linux-foundation.org>
In-Reply-To: <20071113161145.6433e1c1.sfr@canb.auug.org.au>
References: <472F5F8B.7090200@unsolicited.net>
	<E1IpJLy-0002ag-TL@localhost>
	<394337271.18157@ustc.edu.cn>
	<20071107141717.6eb0dc25.sfr@canb.auug.org.au>
	<20071107142609.071532ad.sfr@canb.auug.org.au>
	<394418014.24002@ustc.edu.cn>
	<20071113161145.6433e1c1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 16:11:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Wed, 7 Nov 2007 14:46:47 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> >
> > Thank you(including David:-)) for the confirmation.
> > 
> > Andrew: so mm-speed-up-writeback-ramp-up-on-clean-systems.patch is a
> > safe and working patch ;-)
> 
> So is anything happening with this patch?  It is really necessary to have
> it (or something equivalent) in 2.6.24.
> 

It's in my queue of 2.6.24 stuff.  Along with, umm, 112 other patches.
