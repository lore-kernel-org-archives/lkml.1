Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXKSNwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXKSNwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXKSNvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:51:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34360 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752811AbXKSNvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:51:54 -0500
Date: Mon, 19 Nov 2007 13:50:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tty: Add the new termios2 ioctls to the compatible
 list.
Message-ID: <20071119135002.40303d24@the-village.bc.nu>
In-Reply-To: <20071119125206.GA8623@osiris.boeblingen.de.ibm.com>
References: <20071119125206.GA8623@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 13:52:06 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Make them depend on TCGETS2. If that one is implemented the rest
> should be there as well.
> 
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Alan Cox <alan@redhat.com>
