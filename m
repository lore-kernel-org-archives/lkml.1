Return-Path: <linux-kernel-owner+w=401wt.eu-S935013AbZLGN1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbZLGN1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934807AbZLGN1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:27:06 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:44300 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757007AbZLGN1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:27:05 -0500
Message-ID: <4B1D02F9.4000503@ru.mvista.com>
Date: Mon, 07 Dec 2009 16:28:25 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.33
References: <20091206210752.GA19268@havoc.gtf.org>
In-Reply-To: <20091206210752.GA19268@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

> Nothing world-shakingly-notable.  Notable notables:

> - TRIM work from Christoph and mkp, to make SSD life a bit better
> - PATA fixes and updates from Bart and Alan
> - long overdue removal of 'experimental' tag from PATA driver submenu
>   in Kconfig
> - various bug fixes and minor updates

> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

> to receive the following updates:

[...]

> Alan Cox (6):
>       pata_via: Blacklist some combinations of Transcend Flash and via
>       pata_sis: Implement MWDMA for the UDMA 133 capable chips

    Unfortunately, this patch contains a coding mistake. Probably too late 
to correct it now though Linus hasn't pulled as yet...

MBR, Sergei
