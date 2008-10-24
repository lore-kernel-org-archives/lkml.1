Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYJXJKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYJXJKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYJXJKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:10:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50628 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778AbYJXJKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:10:34 -0400
Date: Fri, 24 Oct 2008 10:10:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] n-tty-output-bells-immediately
Message-ID: <20081024101029.6e826234@lxorguk.ukuu.org.uk>
In-Reply-To: <48FFD4F9.6090105@skyrush.com>
References: <48F2E450.1070508@skyrush.com>
	<20081022103259.2d04729a@lxorguk.ukuu.org.uk>
	<48FFD4F9.6090105@skyrush.com>
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

Ok without randomly hitting send this time...

LC/UC and control characters looks right.  (except the added white space)
Buffer sizing looks fine
Bell definitely a good idea

Those three applied with better subject lines and queued for .29

The last one I'm rather less happy with but want to ponder a bit more the
best way to handle.

Alan
