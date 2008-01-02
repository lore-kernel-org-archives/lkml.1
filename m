Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbYABVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbYABVba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYABVbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:31:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57840 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753697AbYABVbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:31:20 -0500
Date: Wed, 2 Jan 2008 21:21:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Diego Calleja <diegocg@gmail.com>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Message-ID: <20080102212143.01cb82bd@the-village.bc.nu>
In-Reply-To: <20080102211655.GC15898@does.not.exist>
References: <20080102013218.GO27566@does.not.exist>
	<20080102192629.28e67241.diegocg@gmail.com>
	<20080102211655.GC15898@does.not.exist>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stable kernels are mainly meant for usage, not for trying stuff.

You appear to be reinventing history in your attempt to justify removing
CONFIG_EXPERIMENTAL.

> And although I see a point in perhaps shipping some not-yet-perfect 
> device drivers for otherwise unsupported hardware or some
> not-yet-perfect filesystems required for accessing foreign
> (non-Linux) filesystems, I don't see any point in offering a
> WIP Linux-only filesystem in stable kernels.

So that people can use it and test it. Most people don't run -mm or GIT.

Alan
