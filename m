Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbYBFTu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbYBFTu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYBFTus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:50:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203AbYBFTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:50:46 -0500
Date: Wed, 6 Feb 2008 19:44:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zan Lynx <zlynx@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
 tty_poll
Message-ID: <20080206194442.00a4f96a@core>
In-Reply-To: <1202326722.7488.46.camel@localhost>
References: <1202326722.7488.46.camel@localhost>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 12:38:42 -0700
Zan Lynx <zlynx@acm.org> wrote:

> This doesn't happen often so it is rather hard to nail down, but I am
> fairly sure it didn't happen before I started running the 2.6.24 MM
> series kernels.

Do you have the -mm1 hot fixes applied  if its occuring in 2.6.24-mm1 ?

Otherwise tty_poll/wakeup hasn't changed much. It is about to change big
time so I'm glad the bug has popped up before I submit the patches ;)
