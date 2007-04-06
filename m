Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXDFVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXDFVsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXDFVsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:48:38 -0400
Received: from mail.tmr.com ([64.65.253.246]:59302 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148AbXDFVsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:48:37 -0400
Message-ID: <4616C097.1030908@tmr.com>
Date: Fri, 06 Apr 2007 17:50:15 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Valdis.Kletnieks@vt.edu
CC: Maxim Uvarov <muvarov@ru.mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
References: <46124E93.2000408@ru.mvista.com> <16797.1175641303@turing-police.cc.vt.edu>            <4613A4FF.9030202@ru.mvista.com> <6099.1175723450@turing-police.cc.vt.edu>
In-Reply-To: <6099.1175723450@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> 2) It arrived here with some line-wrapping damage, most likely to the fact
> that you posted it with Thunderbird.  There's a mystic Thunderbird incantation
> to make it not do that, but I have no idea what it is - it's in the list
> archives someplace.

I don't use TBird (seamonkey fan) but I assume the patch can just be 
attached rather than inlined. Some mailers are pretty arcane otherwise.

But I do like the idea, but the issue of things which parse 
/proc/PID/status hasn't had comments. A good parser would ignore what it 
didn't understand, or take everything, not everyone has a good parser. ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
