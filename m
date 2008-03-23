Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbYCWM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbYCWM6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbYCWM6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:58:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36816 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbYCWM6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:58:09 -0400
Date: Sun, 23 Mar 2008 12:41:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 126/148] include/asm-x86/termios.h: checkpatch cleanups
 - formatting only
Message-ID: <20080323124157.5e1b47ea@core>
In-Reply-To: <1206259443-13210-127-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
	<1206259443-13210-127-git-send-email-joe@perches.com>
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

On Sun, 23 Mar 2008 01:03:41 -0700
Joe Perches <joe@perches.com> wrote:

> 
> Signed-off-by: Joe Perches <joe@perches.com>

NAK - all serial/tty changes in this set.

Please leave the tty code alone for now (all of it). You are getting in
the way of far more important work and the changes you make add no real
value so should be done when nothing else is happening
