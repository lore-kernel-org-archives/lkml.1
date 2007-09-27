Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbXI0QTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbXI0QTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXI0QTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:19:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46395 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754753AbXI0QTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:19:07 -0400
Date: Thu, 27 Sep 2007 17:24:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: correct kernel parameter in documentation.
Message-ID: <20070927172438.611b2bb0@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0709271202210.13117@localhost.localdomain>
References: <20070927155013.GA20219@redhat.com>
	<Pine.LNX.4.64.0709271202210.13117@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> if you're going to add that libata-related parm to the kernel parms
> file, wouldn't it make sense for consistency to add the other
> available boot-time parms from libata-core.c as well?  it seems
> counter-productive to document only a subset of them from the same
> source file.

He's not adding it - he's correcting a bug
