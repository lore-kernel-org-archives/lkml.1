Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbYJYPsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbYJYPsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 11:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYJYPsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 11:48:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49775 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204AbYJYPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 11:48:30 -0400
Date: Sat, 25 Oct 2008 16:48:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] n-tty-output-bells-immediately
Message-ID: <20081025164829.0b602e6e@lxorguk.ukuu.org.uk>
In-Reply-To: <49033E1B.9030406@skyrush.com>
References: <48F2E450.1070508@skyrush.com>
	<20081022103259.2d04729a@lxorguk.ukuu.org.uk>
	<48FFD4F9.6090105@skyrush.com>
	<20081024101029.6e826234@lxorguk.ukuu.org.uk>
	<49033E1B.9030406@skyrush.com>
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

> BTW, where are the patches sitting at this point?  I saw an email about
> "linux-next" that lists just the first of the 3 (the drop bkl one); and
> your tty git is now empty.  Just curious.

Stephen asked that there was nothing being picked up for next that wasn't
.28 material for the moment.

Alan
