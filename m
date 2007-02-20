Return-Path: <linux-kernel-owner+w=401wt.eu-S965082AbXBTPiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbXBTPiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965083AbXBTPiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:38:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45123 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965082AbXBTPiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:38:23 -0500
Date: Tue, 20 Feb 2007 16:39:39 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Adrian `trivial' Bunk" <bunk@stusta.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty_register_driver: Remove incorrect and superfluous
 cast
Message-ID: <20070220163939.69cfbfb3@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.62.0702201542510.10709@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0702201542510.10709@pademelon.sonytel.be>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 15:45:21 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> tty_register_driver: Remove incorrect and superfluous cast (expected and passed
> types are both const char *)
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: Alan Cox <alan@redhat.com>
