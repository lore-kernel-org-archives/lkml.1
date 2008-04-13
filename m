Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYDMShS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYDMShS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYDMShF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:37:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38312 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750700AbYDMShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:37:05 -0400
Date: Sun, 13 Apr 2008 19:33:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: monte <monte@eslashlonghorns.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel bug
Message-ID: <20080413193305.60336a32@core>
In-Reply-To: <48022F82.80704@eslashlonghorns.com>
References: <48022F82.80704@eslashlonghorns.com>
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

On Sun, 13 Apr 2008 10:06:26 -0600
monte <monte@eslashlonghorns.com> wrote:

> Since I am new at this, this is the info you may need.
> 
> I am trying to using Ubuntu hardy (development branch), Kernel 
> 2.6.24-16, and get the following error
> 
> error 18: selected cylinder exceeds maximum supported by BIOS.

That isn't a kernel message as far as I can tell, it would seem to be one
from the boot loader, and probably indicates your distribution does not
set boot partitions up correctly - you should repor tit to the Ubuntu
people.
