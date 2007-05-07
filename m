Return-Path: <linux-kernel-owner+w=401wt.eu-S966992AbXEGVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966992AbXEGVjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966867AbXEGVje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:39:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58085 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966516AbXEGVjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:39:33 -0400
Date: Mon, 7 May 2007 22:43:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070507224328.5375f276@the-village.bc.nu>
In-Reply-To: <20070507203812.GA18400@elf.ucw.cz>
References: <20070503213303.GH20067@zarina>
	<20070507140453.GD3868@ucw.cz>
	<1178550653.11851.191.camel@pmac.infradead.org>
	<20070507194949.GB3981@ucw.cz>
	<1178567497.11851.229.camel@pmac.infradead.org>
	<20070507203812.GA18400@elf.ucw.cz>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ...which is pretty unhelpful. We still stick to 80 columns in the
> code, and bigger displays certainly predate utf-8 compatibility. Plus,
> you'd have to convert large part of Czech republic before I could
> reasonably use utf-8).

Maybe its about time they started. And since you can flip an editor into
utf-8 for working on kernel code its not a big deal.
