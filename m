Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZJLT73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZJLT73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZJLT72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:59:28 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:3182 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbZJLT70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:59:26 -0400
Subject: Re: 2.6.32-rc4: Reported regressions 2.6.30 -> 2.6.31
From: Andrew Patterson <andrew.patterson@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
In-Reply-To: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 13:58:48 -0600
Message-Id: <1255377529.9544.63.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 00:41 +0200, Rafael J. Wysocki wrote:
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14309
> Subject		: MCA on hp rx8640
> Submitter	: Andrew Patterson <andrew.patterson@hp.com>
> Date		: 2009-09-29 17:20 (13 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db8be50c4307dac2b37305fc59c8dc0f978d09ea
> References	: http://www.spinics.net/lists/linux-usb/msg22799.html
> 

Linus fixed this one with d93a8f829fe1d2f3002f2c6ddb553d12db420412.  It
also looks like a duplicate of
http://bugzilla.kernel.org/show_bug.cgi?id=14374

Thanks,

Andrew
-- 
Andrew Patterson
Hewlett-Packard

