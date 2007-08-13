Return-Path: <linux-kernel-owner+w=401wt.eu-S945928AbXHMNyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945928AbXHMNyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbXHMKfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:35:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58337 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765245AbXHMKfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:35:18 -0400
Date: Mon, 13 Aug 2007 11:42:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: postfail@hushmail.com
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4 of 5 ] /drivers/char/rio ioremap balancing/ returncode
 check
Message-ID: <20070813114235.1a2f6484@the-village.bc.nu>
In-Reply-To: <20070813040530.9E0E9DA82E@mailserver8.hushmail.com>
References: <20070813040530.9E0E9DA82E@mailserver8.hushmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 00:05:30 -0400
"Scott Thompson" <postfail@hushmail.com> wrote:

> patchset against 2.6.23-rc2 and this set is an audit of 
> /drivers/char/a* 
> through drivers/char .   
> 
> this corrects missing ioremap return checks and balancing on 
> iounmap calls..

Your mail client has wrapped the patches. Please resend without wrapping
