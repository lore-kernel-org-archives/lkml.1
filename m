Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbXEEJPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbXEEJPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 05:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423148AbXEEJPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 05:15:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42921 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754529AbXEEJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 05:15:16 -0400
Date: Sat, 5 May 2007 10:18:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty_set_ldisc receive_room fix
Message-ID: <20070505101836.5b8d97c1@the-village.bc.nu>
In-Reply-To: <1178307722.3743.8.camel@amdx2.microgate.com>
References: <1178307722.3743.8.camel@amdx2.microgate.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Previously (< 2.6.18) this was not a problem because
> the tty flip buffer pushed data to the line discipline
> without regard for tty->receive room.

 
> Signed-off-by: Paul Fulghum <paulkf@microgate.com>

Acked-by: Alan Cox <alan@redhat.com>
