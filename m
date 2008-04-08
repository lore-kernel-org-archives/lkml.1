Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbYDHMSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbYDHMSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 08:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYDHMS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 08:18:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55470 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbYDHMS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 08:18:27 -0400
Date: Tue, 8 Apr 2008 13:10:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, R.E.Wolff@BitWizard.nl
Subject: Re: [PATCH] drivers/char/specialix.c: stop inlining largish static
 functions
Message-ID: <20080408131036.243fe896@core>
In-Reply-To: <20080408114321.GB1236@bitwizard.nl>
References: <200804081244.53894.vda.linux@googlemail.com>
	<20080408114321.GB1236@bitwizard.nl>
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

> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> Ack!
> 
> Signed-off-by: Rogier Wolff <R.E.Wolff@BitWizard.nl> 

Acked-by: Alan Cox <alan@redhat.com>

Works for me. I have other patches that touch the same file but nothing
overlapping or that will be hard to resolve.
