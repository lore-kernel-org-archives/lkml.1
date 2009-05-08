Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbZEHMos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbZEHMos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZEHMoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:44:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41283 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZEHMoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:44:37 -0400
Date: Fri, 8 May 2009 06:44:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
Message-ID: <20090508124436.GT8112@parisc-linux.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <20090508111024.GD11596@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508111024.GD11596@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 01:10:24PM +0200, Ingo Molnar wrote:
> ( Cc:-ed PCI folks. Original thread with patches is on lkml. There's
>   a few details that affect non-Xen PCI code too - and it would be
>   nice to see feedback on this general method as well, from the PCI 
>   experts . )

I read over the top seven commits here:
http://git.kernel.org/?p=linux/kernel/git/jeremy/xen.git;a=shortlog;h=xen-tip/dom0/pci
and they all seem reasonable to me as far as they affect other code.
I'm assuming that Xen people know what they're doing with respect to
the Xen-only code ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
