Return-Path: <linux-kernel-owner+w=401wt.eu-S1161242AbXDQUQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161242AbXDQUQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXDQUQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:16:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33394 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161242AbXDQUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:16:48 -0400
Date: Tue, 17 Apr 2007 13:16:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, holger@eiboeck.de
Subject: Re: RFC: drivers/char/watchdog/pcwd.c +
 drivers/char/watchdog/pcwd_pci.c
Message-Id: <20070417131624.5ae58d63.akpm@linux-foundation.org>
In-Reply-To: <20070417185849.GA2632@infomag.infomag.iguana.be>
References: <20070417185849.GA2632@infomag.infomag.iguana.be>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 17 Apr 2007 20:58:49 +0200 Wim Van Sebroeck <wim@iguana.be> wrote:
> Would anyone object if we would merge the "full bells and whistles" drivers for
> the pcwd isa and pci cards in the kernel tree. (It basically only adds some extra
> /proc routines). This would make it easier to maintain the "full bells and whistles"
> driver.

It's hard to answer that question.  Please send the patches out in the
usual manner for review and comment.
