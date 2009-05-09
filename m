Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZEIUIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZEIUIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZEIUII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 16:08:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51379 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZEIUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 16:08:07 -0400
Date: Sat, 9 May 2009 14:08:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
Message-ID: <20090509200805.GA26487@parisc-linux.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <20090508111024.GD11596@elte.hu> <20090508124436.GT8112@parisc-linux.org> <4A05A493.7050107@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A05A493.7050107@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 08:43:15AM -0700, Jeremy Fitzhardinge wrote:
> Thanks.  Can I put your acked-by on those 7 changes (after fixing the  
> __init thing Yinghai mentioned)?

Certainly, though I think Reviewed-by would be more appropriate?

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
