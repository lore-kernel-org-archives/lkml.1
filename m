Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbYJMIlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbYJMIlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbYJMIl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:41:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33106 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754790AbYJMIl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:41:27 -0400
Date: Mon, 13 Oct 2008 09:40:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix n_tty/pty input/output buffer full and other misc
 char handling
Message-ID: <20081013094050.44ecf8d9@lxorguk.ukuu.org.uk>
In-Reply-To: <48F2E450.1070508@skyrush.com>
References: <48F2E450.1070508@skyrush.com>
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

On Mon, 13 Oct 2008 00:01:52 -0600
Joe Peterson <joe@skyrush.com> wrote:

> Alan,
> 
> As promised, here is a patch to apply after the latest combined echo
> buffer patch I recently sent.  It fixes a few things, but most

Thanks - queued. Will start looking at tty stuff once the current pile is
merged.

Alan
