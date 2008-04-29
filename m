Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYD2Vxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYD2Vxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYD2VxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:53:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55102 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752920AbYD2VxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:53:24 -0400
Date: Tue, 29 Apr 2008 22:43:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HP server and atto driver from hell
Message-ID: <20080429224350.51006a5c@core>
In-Reply-To: <20080429201727.GV8066@charite.de>
References: <20080429201727.GV8066@charite.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 22:17:27 +0200
Ralf Hildebrandt <Ralf.Hildebrandt@charite.de> wrote:

> We thought HP would be a smart choice when it comes to Linux,..
> Until now, because now we have to use a PCI Express SCSI card that
> comes with a proprietary driver that won't even compile.

I would suggest you take it up with the supplier, given EU law on product
being fit for the purpose for which it was sold I would hope they jump.

Seriously it isn't going to be worth anyones time fighting binary crap
when there are open alternatives available. Tell HP to replace it with a
working card - also if you mail ordered it remember your EU wide 14 day
return option ;)

And please don't post pieces of proprietary driver code to the kernel
list - I doubt you have permission to do so from HP.

Alan
