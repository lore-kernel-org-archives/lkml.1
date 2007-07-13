Return-Path: <linux-kernel-owner+w=401wt.eu-S934920AbXGMUZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934920AbXGMUZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbXGMUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:24:58 -0400
Received: from stinky.trash.net ([213.144.137.162]:49340 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbXGMUY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:24:58 -0400
Message-ID: <4697DF7F.3030400@trash.net>
Date: Fri, 13 Jul 2007 22:24:31 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Chuck Ebbert <cebbert@redhat.com>, neilb@suse.de,
       nfs@lists.sourceforge.net,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: nfsd oops in current -git
References: <469780BB.3070206@trash.net> <4697A7EC.6050006@redhat.com> <20070713163337.GT5328@kernel.dk> <20070713165001.GV5328@kernel.dk>
In-Reply-To: <20070713165001.GV5328@kernel.dk>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>>>On 07/13/2007 09:40 AM, Patrick McHardy wrote:
>>>
>>>>I get this oops with current -git:
>>>>
>>>>[ 3437.018923] Pid: 4432, comm: nfsd Not tainted 2.6.22 #5
>>>>[ 3437.018926] RIP: 0010:[<ffffffff81054eff>]  [<ffffffff81054eff>]
>>>>put_page+0x4/0xb3

> Patrick, does this work?


Seems to work fine, thanks Jens.

