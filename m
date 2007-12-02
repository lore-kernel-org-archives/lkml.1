Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbXLBABk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbXLBABk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbXLBABa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:01:30 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:15530 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXLBAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:01:29 -0500
Message-ID: <4751F5CC.8020904@chelsio.com>
Date: Sat, 01 Dec 2007 16:01:16 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [LIKELY_SPAM][git patches] net driver fixes
References: <20071201233711.GA9698@havoc.gtf.org>
In-Reply-To: <20071201233711.GA9698@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2007 23:59:57.0046 (UTC) FILETIME=[464F8160:01C83476]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>
> Notes:
>
> 1) Several of these are resends from the last submission.
>
> 2) That chelsio file mode change (644->755) is a bit annoying.  Can git
> do chmod as a changeset by itself?
>

Sorry for this. I had not noticed it.
If any help, I just submitted a patch reverting the file mode changes.

Cheers,
Divy
