Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYGYGQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYGYGQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 02:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYGYGQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 02:16:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:60439 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYGYGQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 02:16:29 -0400
Subject: sfx.c driver build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Michael Brown <mbrown@fensystems.co.uk>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Jul 2008 16:15:59 +1000
Message-Id: <1216966559.11188.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael !

The sfx driver (which happens to be part of some of our test configs)
fails to build in current Linus tree on powerpc with this error:

/home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c: In function ‘efx_probe_interrupts’:
/home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c:845: error: lvalue required as unary ‘&’ oper
and

Cheers,
Ben.


