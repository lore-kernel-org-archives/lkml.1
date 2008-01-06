Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYAFNiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYAFNiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYAFNiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:38:01 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59757 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752748AbYAFNiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:38:00 -0500
Date: Sun, 6 Jan 2008 13:36:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Forcing modes in libata (was: SATA buffered read VERY slow)
Message-ID: <20080106133609.51203eed@lxorguk.ukuu.org.uk>
In-Reply-To: <200801060803.31939.a1426z@gawab.com>
References: <200801051641.03927.a1426z@gawab.com>
	<20080105163016.608b1e7f@lxorguk.ukuu.org.uk>
	<200801060803.31939.a1426z@gawab.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 08:03:31 +0300
> > For now you can boot with libata.dma=1 to select DMA on disks but not CD
> 
> Great, but why isn't this in the documentation?

Send patches
