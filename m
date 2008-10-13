Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYJMJZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYJMJZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbYJMJZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:25:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49997 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbYJMJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:25:06 -0400
Date: Mon, 13 Oct 2008 10:24:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH] tty: remove the BKL in n_tty.c
Message-ID: <20081013102458.3161441d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081013084719.03972D1B9DE@perso1.free.fr>
References: <20081013084719.03972D1B9DE@perso1.free.fr>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know where to post this patch. I'm not sure if the kill-the-bkl is 
> still on the air on the -tip tree.

There are patches pending for this already along with other n_tty
ordering fixes, they will enter the ttydev tree once the current ttydev
tree reaches Linus.

Alan
