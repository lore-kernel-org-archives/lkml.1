Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYGTX70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYGTX70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYGTX7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:59:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:56685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbYGTX7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:59:11 -0400
Subject: Re: Btrfs hosting moving to kernel.org
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, btrfs-devel@oss.oracle.com
In-Reply-To: <200804011416.43563.chris.mason@oracle.com>
References: <200804011416.43563.chris.mason@oracle.com>
Content-Type: text/plain
Organization: Intel Corporation
Date: Sun, 20 Jul 2008 16:59:10 -0700
Message-Id: <1216598351.2475.222.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 14:16 -0400, Chris Mason wrote:
> Sources:
> 
> http://www.kernel.org/hg/btrfs/

Since it turns out that using something other than git for kernel
development _wasn't_ just an April Fools joke, I've started mirroring
into git. I hope that's OK:

http://git.kernel.org/?p=linux/kernel/git/dwmw2/btrfs-kernel-unstable.git
http://git.kernel.org/?p=linux/kernel/git/dwmw2/btrfs-progs-unstable.git
http://git.kernel.org/?p=linux/kernel/git/dwmw2/btrfs-kernel.git
http://git.kernel.org/?p=linux/kernel/git/dwmw2/btrfs-progs.git

It should be updated hourly.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


