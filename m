Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbXGFKMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbXGFKMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbXGFKMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:12:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50526 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760131AbXGFKMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:12:33 -0400
Date: Fri, 6 Jul 2007 11:18:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
Message-ID: <20070706111848.43551f33@the-village.bc.nu>
In-Reply-To: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 10:21:32 +0200
Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de> wrote:

> Hello,
> 
> In the newest Ubuntu Release, my PATA-disk is called sda instead of hda.
> Is that a general feature in newer kernel versions or is it a special
> feature in Ubuntu?

General. SATA and now PATA drives map onto the /dev/sd range as do SCSI,
USB etc
