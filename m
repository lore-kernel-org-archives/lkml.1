Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYGIObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYGIObR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYGIObE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:31:04 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:1542 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYGIObB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:31:01 -0400
Date: Wed, 9 Jul 2008 16:30:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 9
Message-ID: <20080709143028.GA24152@osiris.boeblingen.de.ibm.com>
References: <20080709183047.0eb1eb72.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709183047.0eb1eb72.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 06:30:47PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080708:
> 
> Temporarily dropped tree: ttydev (since it would not import on top of any
> tree I have)
> 
> The x86 tree lost a conflict against the ftrace tree.
> 
> The ide tree gained 2 conflicts against Linus' tree.
> 
> The nfs tree gained a conflict against Linus' tree.
> 
> The acpi tree lost 5 conflicts against various trees but gained another
> against the x86 tree.
> 
> The net tree lost 2 conflicts against the x86 wireless-current trees.
> 
> I have also applied the following patches for known problems (I assume
> that these will be merged into their appropriate trees shortly):
> 
> 	linux-next: zero based percpu build error on s390

Ingo, will you merge/pick this patch up? The original patch which causes
the problems came in via one of your git trees. Patch in question is

"Zero based percpu: infrastructure to rebase the per cpu area to zero"

Thanks.
