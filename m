Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXBSPSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXBSPSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbXBSPSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:18:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:1823 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932344AbXBSPSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:18:52 -0500
Message-ID: <45D9BFD2.6030509@ru.mvista.com>
Date: Mon, 19 Feb 2007 18:18:42 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] more IDE updates
References: <200702170325.02337.bzolnier@gmail.com>
In-Reply-To: <200702170325.02337.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> Contains: IRQ-ack fix for ICH chipsets (Albert Lee), ide-floppy unformatted
> media fix (Alan Cox), more fixes for IDE PCI drivers (Sergei Shtylyov),
> new driver for Toshiba Cell Reference Board (Kou Ishizaki <kou.ishizaki
> at toshiba.co.jp>) and a bunch of rather obvious cleanups/improvements (me).
> 
> There are still some bugfix patches in my tree which should go into 2.6.21
> but since they are quite fresh and there have already been a lot of IDE
> changes since the merge window was opened I will wait for -rc1 to push
> them upstream.
> 
> [ Andrew, IDE quilt tree has already been updated wrt to this update ]

    Which quilt tree do you mean? I've noticed that in 
http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/ the series file 
itself hasn't been updated, so this tree appears broken currently.

WBR, Sergei
