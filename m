Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZLCNhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZLCNhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZLCNhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:37:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZLCNhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:37:01 -0500
Date: Thu, 3 Dec 2009 14:37:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 3
In-Reply-To: <20091203180214.16e452ed.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.0912031435380.9567@twin.jikos.cz>
References: <20091203180214.16e452ed.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Stephen Rothwell wrote:

> Changes since 20091202:
> 
> New tree: kbuild-current
> 
> The powerpc tree lost its build failure.
> 
> The ext3 tree gained a build failure for which I reverted a commit.
> 
> The net tree lost a conflict.
> 
> The mtd tree gained a conflict against the mips tree.
> 
> The tip tree lost a conflict.
> 
> The workqueues tree lost its conflicts.
[ ... ]
> Below is a summary of the state of the merge.
[ ... ]
> Merging trivial/for-next
> CONFLICT (content): Merge conflict in Documentation/video4linux/gspca.txt

Hi Stephen,

have you been sending out e-mail about this conflict? I don't seem to have 
received any.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

