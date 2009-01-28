Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbZA1KQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbZA1KQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZA1KQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:16:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56388 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbZA1KQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:16:47 -0500
Date: Wed, 28 Jan 2009 10:16:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128101641.33978100@lxorguk.ukuu.org.uk>
In-Reply-To: <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
References: <20090128033824.GA1662@brong.net>
	<59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
	<alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
	<2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
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

> It's really simple. A kernel upgrade in a -stable series point release
> broke a rational user-space setup. If you don't want to adjust the

You can just as equally load the description the other way:

"A kernel upgrade in a -stable series point release fixed a security DoS"

Which is not to say that a smarter limit isn't needed.

Alan
