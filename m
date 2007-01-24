Return-Path: <linux-kernel-owner+w=401wt.eu-S1751019AbXAXTkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbXAXTkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXAXTkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:40:52 -0500
Received: from homer.mvista.com ([63.81.120.155]:57047 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbXAXTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:40:51 -0500
Message-ID: <45B7B63E.70608@ru.mvista.com>
Date: Wed, 24 Jan 2007 22:40:46 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
  er
References: <45B78C19.4030408@pmc-sierra.com>
In-Reply-To: <45B78C19.4030408@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Marc St-Jean wrote:

>>http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc4/2.6.20-rc4-mm1/broken-out/8250-uart-backup-timer.patch

> This second patch failure description is identical to what we are seeing without
> the THRE work-around. This must be the timer patch Alan mentioned but it's not
> in the linux.git at l-m.o.

    Yeah, it must still be considered "experimental" as it resides only within 
the -mm tree.

> Could you please explain what you mean by and where I can find the "-mm tree"?

    http://kernel.org/patchtypes/mm.html

    As the serial drivers have no maintainer now, you probably have to CC the 
final patch to Andrew Morton (akpm@osdl.org), so it'd be better to be 
applicable against the recent -mm patch.

> Marc

MBR, Sergei
