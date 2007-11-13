Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXKMW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXKMW6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbXKMW6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:58:06 -0500
Received: from [81.2.110.250] ([81.2.110.250]:48557 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760183AbXKMW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:58:05 -0500
Date: Tue, 13 Nov 2007 22:57:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ron Yorgason" <yorgasor@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Better support for Delkin cardbus CF adapters -- IDE layer
Message-ID: <20071113225722.36ed3a30@the-village.bc.nu>
In-Reply-To: <93d1fdd10711131404u4bdf1d08pb3f579e370c125f0@mail.gmail.com>
References: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
	<20071112194806.4cb9c688@the-village.bc.nu>
	<93d1fdd10711131404u4bdf1d08pb3f579e370c125f0@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 17:04:57 -0500
"Ron Yorgason" <yorgasor@gmail.com> wrote:

> I received a response from Synchrotech, the supplier of one of my
> cards.  He said that they were under NDA with their manufacturing
> partner and couldn't offer the full specs.  However he could tell me
> the specific bridge chip:
> 
> JMicron JMB368 PCIe to PATA controller

Seems odd for the cardbus controller as cardbus is PCI not PCIe but would
make sense for Expresscard devices. In theory a Jmicron plug in card
would just work.

