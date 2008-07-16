Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYGPS4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYGPS4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYGPS42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:56:28 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:49030 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYGPS42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:56:28 -0400
Date: Wed, 16 Jul 2008 14:56:27 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: 64bit kernel not booting with CONFIG_PRINTK_TIME=y
Message-ID: <20080716185627.GC22716@phobos.i.cabal.ca>
References: <20080716204552.56270e7c@tuxicoman.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716204552.56270e7c@tuxicoman.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 08:45:52PM +0200, Guy Martin wrote:
> 
> This is the output of my L2000 when trying to do so :
> 
> Information: No console specified on kernel command line. This is
> normal. PALO will choose the console currently used by firmware
> (serial). Command line for kernel: 'root=/dev/md1 console=ttyS0
> palo_kernel=2/vmlinux' Selected kernel: /vmlinux from partition 2
> ELF64 executable
> Entry 00100000 first 00100000 n 2
> Segment 0 load 00100000 size 4997120 mediaptr 0x1000
> Segment 1 load 00634000 size 640576 mediaptr 0x4c5000
> Branching to kernel entry point 0x00100000.  If this is the last
> message you see, you may need to switch your console.  This is
> a common symptom -- search the FAQ and mailing list at parisc-linux.org
> 

Wrong mailing list. :)
