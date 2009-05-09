Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZEINdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZEINdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZEINcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:32:51 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36062 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZEINcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:32:50 -0400
Date: Sat, 9 May 2009 07:32:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
Message-ID: <20090509133249.GZ8112@parisc-linux.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <20090508111024.GD11596@elte.hu> <20090508124436.GT8112@parisc-linux.org> <4A048C11.1050702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A048C11.1050702@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 12:46:25PM -0700, Yinghai Lu wrote:
> 1. pcibios_set_cache_line_size looks could be __init

Yes, good catch.  Agreed.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
