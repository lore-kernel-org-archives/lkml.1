Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbXGQBBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbXGQBBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbXGQBBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:01:17 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:52897 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757AbXGQBBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:01:14 -0400
Message-ID: <469C1498.8010500@gmail.com>
Date: Tue, 17 Jul 2007 03:00:08 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: utz lehmann <lkml123@s2y4n2c.de>
CC: Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it>	 <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>	 <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>	 <E1  <469BF104.1040703@gmail.com> <1184628395.8707.15.camel@segv.aura.of.mankind>
In-Reply-To: <1184628395.8707.15.camel@segv.aura.of.mankind>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 01:26 AM, utz lehmann wrote:

> I have to recompile the fedora kernel rpms (fc6, f7) with 8k stacks on my
> i686 server. It's using NFS -> XFS -> DM -> MD (raid1) -> IDE disks. With
> 4k stacks it crash (hang) within minutes after using NFS. With 8k stacks
> it's rock solid. No crashes within months.

Okay, thanks. That's the usual offender. And only one I've heard of...

Rene.

