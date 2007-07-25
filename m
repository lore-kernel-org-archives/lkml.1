Return-Path: <linux-kernel-owner+w=401wt.eu-S934653AbXGYRgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbXGYRgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbXGYRg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:36:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40842 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932214AbXGYRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:36:26 -0400
Date: Wed, 25 Jul 2007 18:43:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
Message-ID: <20070725184312.44ca7a8c@the-village.bc.nu>
In-Reply-To: <20070725165318.5331.23795.stgit@localhost.localdomain>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> pata_platform and ide_platform are carrying same driver names,
> to easily switch between these drivers, without need to touch
> platform code.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

Acked-by: Alan Cox <alan@redhat.com>

