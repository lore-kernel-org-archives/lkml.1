Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbYBRU1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbYBRU1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYBRU1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:27:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53535 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752562AbYBRU1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:27:05 -0500
Date: Mon, 18 Feb 2008 20:17:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org,
       "David P. Reed" <dpreed@reed.com>
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in
 kernel and pcspkr driver
Message-ID: <20080218201740.723b3944@core>
In-Reply-To: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net>
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net>
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

On Mon, 18 Feb 2008 13:58:41 -0500 (EST)
"David P. Reed" <dpreed@reed.com> wrote:

> x86: use explicit timing delay for pit accesses in kernel and pcspkr driver

Both look good to me now
