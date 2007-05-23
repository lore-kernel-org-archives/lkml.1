Return-Path: <linux-kernel-owner+w=401wt.eu-S1761905AbXEWUTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761905AbXEWUTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXEWUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:19:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38209 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756164AbXEWUTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:19:38 -0400
Date: Wed, 23 May 2007 21:24:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.21.1: ide-pci is not finding ide controller.
Message-ID: <20070523212425.68897280@the-village.bc.nu>
In-Reply-To: <20070523201118.GZ5921@austin.ibm.com>
References: <20070523201118.GZ5921@austin.ibm.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 15:11:18 -0500
linas@austin.ibm.com (Linas Vepstas) wrote:

> 
> I've got a rather old x86 box that I'm booting 2.6.21.1 on;
> this kernel is not finding an ide controller on it. 

HPT366 fixes were posted here earlier. It doesn't in fact have reliable
enable bits.
