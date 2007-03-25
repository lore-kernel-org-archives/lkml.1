Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbXCYFMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbXCYFMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933196AbXCYFMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:12:13 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:3233 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191AbXCYFMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:12:13 -0400
From: Paul Collins <paul@briny.ondioline.org>
To: David Miller <davem@davemloft.net>
Cc: bunk@stusta.de, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jareguero@telefonica.net,
       oliver.pntr@gmail.com, g3vbv@blueyonder.co.uk
Subject: Re: [1/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070323184816.GO752@stusta.de>
	<20070324.214509.98750566.davem@davemloft.net>
Date: Sun, 25 Mar 2007 17:08:52 +1200
In-Reply-To: <20070324.214509.98750566.davem@davemloft.net> (David Miller's
	message of "Sat\, 24 Mar 2007 21\:45\:09 -0700 \(PDT\)")
Message-ID: <877it59afv.fsf@briny.internal.ondioline.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> Furthermore, his scripts don't even execute properly when
> I try to run them myself, for example server.py gives me
> this syntax error when python tries to parse the script:
>
> davem@sunset:~/src/GIT/net-2.6$ /usr/bin/python server.py
>   File "server.py", line 9
>     struct sockaddr_in ServerAddr;
>                      ^
> SyntaxError: invalid syntax

The reporter's client and server code seem to be C, but if the he thinks
they should be Python, I guess they're not the correct ones anyway.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
