Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbXA2FZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbXA2FZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 00:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbXA2FZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 00:25:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43804
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933125AbXA2FZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 00:25:56 -0500
Date: Sun, 28 Jan 2007 21:25:54 -0800 (PST)
Message-Id: <20070128.212554.23015561.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: benh@kernel.crashing.org, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	<20070128.153707.30184351.davem@davemloft.net>
	<m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jan 2007 22:18:59 -0700

> Regardless of my opinion on the sanity of the hypervisor architects.
> I have not seen anything that indicates it will be hard to support
> the hypervisor doing everything or most of everything for us, so
> I see no valid technical objection to it.  Nor have I ever.
> 
> So I have no problem with additional patches in that direction.

Ok, that's great to hear.

I know your bi-directional approach isn't exactly what Ben
wants but he can support his machines with it.  Maybe after
some time we can agree to move from that more towards the
totally abstracted scheme.
