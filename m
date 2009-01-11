Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZAKWQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZAKWQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZAKWQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:16:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:59124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZAKWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:16:01 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090111.133929.57600645.davem@davemloft.net>
References: <43805.1231672258@turing-police.cc.vt.edu>
	 <20090111.040842.86784676.davem@davemloft.net>
	 <1231676698.25018.147.camel@macbook.infradead.org>
	 <20090111.133929.57600645.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 22:15:54 +0000
Message-Id: <1231712154.25018.672.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 13:39 -0800, David Miller wrote:
> 
> For example, for mounting an NFS root using that device.... Oh, will I
> need an initramfs for that once you pull the firmware-in-kernel
> option?

Of course, we've been talking for ages about pulling the dhcp and
nfsroot hacks from the kernel and requiring an initrd for that _anyway_,
but that's a different issue...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

