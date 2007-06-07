Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXFGPwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXFGPwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765584AbXFGPwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:52:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48904 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764616AbXFGPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:52:07 -0400
Date: Thu, 7 Jun 2007 16:52:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: casey@schaufler-ca.com
Cc: Steve Grubb <sgrubb@redhat.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Miloslav Trmac <mitr@redhat.com>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
Message-ID: <20070607165259.51405f43@the-village.bc.nu>
In-Reply-To: <817517.5859.qm@web36605.mail.mud.yahoo.com>
References: <200706070650.50100.sgrubb@redhat.com>
	<817517.5859.qm@web36605.mail.mud.yahoo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> logging to meet the audit requirements. You have to log what happened.
> Logging what was requested is insufficient and logging what was
> typed, which may or may not have resulted in an actual request is
> not helpful to meeting security audit requirements.

Key information can answer some questions as an additional adjunct, but
all of this really depends whether your security audit requirement is to
impress the monkeys or to protect your systems (or as usually is the case
to protect your system while still impressing a bunch of half-trained 19
year old box tickers on their first outing doing auditing)


