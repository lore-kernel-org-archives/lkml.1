Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXLKN2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXLKN2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXLKN2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:28:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59807 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752124AbXLKN2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:28:06 -0500
Date: Tue, 11 Dec 2007 13:22:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: linux-pcmcia@lists.infradead.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 2/6] pcmcia/3c574_cs: Fix 'shadow variable' warning
Message-ID: <20071211132222.598d69ec@the-village.bc.nu>
In-Reply-To: <20071211043417.28518.39249.sendpatchset@thinktank.campus.ltu.se>
References: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
	<20071211043417.28518.39249.sendpatchset@thinktank.campus.ltu.se>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 05:32:43 +0100 (MET)
Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> Fixing:
>   CHECK   drivers/net/pcmcia/3c574_cs.c
> drivers/net/pcmcia/3c574_cs.c:695:7: warning: symbol 'i' shadows an earlier one
> drivers/net/pcmcia/3c574_cs.c:636:6: originally declared here
> 
> Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>

For 2/3/4/5/6:

Acked-by: Alan Cox <alan@redhat.com>

Not sure I agree with the first patch though.
