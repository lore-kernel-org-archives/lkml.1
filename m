Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYKPAHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYKPAHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYKPAHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:07:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42067 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685AbYKPAHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:07:37 -0500
Date: Sun, 16 Nov 2008 00:07:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081116000738.5c70daf5@lxorguk.ukuu.org.uk>
In-Reply-To: <1226793823-32360-3-git-send-email-bwalle@suse.de>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de>
	<1226793823-32360-3-git-send-email-bwalle@suse.de>
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

On Sun, 16 Nov 2008 01:03:43 +0100
Bernhard Walle <bwalle@suse.de> wrote:

> When CONFIG_STRICT_DEVMEM is set, live debugging is not possible with the
> crash utility (see http://people.redhat.com/~anderson). For distributors
> who ship a generic kernel it's difficult: Disabling CONFIG_STRICT_DEVMEM
> is possible, but in general the protection provided by CONFIG_STRICT_DEVMEM
> is useful. However, live debugging should be still neceessary.

Why not just turn strictmem off - as you've correctly demonstrated its
completely useless and always was.

A switchable configurable piece of turd is still at the end of the day a
piece of turd.

