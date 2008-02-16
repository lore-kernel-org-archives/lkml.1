Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYBPPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYBPPOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYBPPOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:14:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35307 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbYBPPN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:13:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Feb 2008 16:13:40 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux-next: first tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
Message-ID: <tkrat.2485199a86a3fbb3@s5r6.in-berlin.de>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Feb, Stephen Rothwell wrote at LKML:
> I have created the first cut of the linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> Things to know about this tree:
> 
> It has two branches - master and stable.  Stable is currently just Linus'
> tree and will never rebase.  Master will rebase on an almost daily basis
> (maybe slower at the start).
> 
> The tree consists of subsystem git and quilt trees.

Stephen, please add the for-next branch of linux1394-2.6.git to your
tree to receive updates for drivers/firewire/ and drivers/ieee1394/.
The URL is

    master.kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-next

or via git protocol:

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-next

Contact addresses are:

    Stefan Richter <stefanr@s5r6.in-berlin.de>
    <linux1394-devel@lists.sourceforge.net>

Thanks.
-- 
Stefan Richter
-=====-==--- --=- =----
http://arcgraph.de/sr/

