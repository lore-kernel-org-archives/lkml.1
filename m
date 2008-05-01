Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbYEANyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbYEANyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYEANyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:54:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45995 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEANyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:54:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4819CB85.2040809@s5r6.in-berlin.de>
Date: Thu, 01 May 2008 15:54:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <200804302245.50817.rjw@sisk.pl>
In-Reply-To: <200804302245.50817.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> And what do you think is happening _after_ the merge window closes, when
> we're supposed to be fixing bugs?  People work on new code.

That's not correct.  People work on new code before, during, and after 
the merge window.  They also fix bugs before, during, and after it.

> And, in fact, they have to, if they want to be ready for the next merge
> window.

To be ready for the next merge window just means to know which code is 
sufficiently reviewed and tested, and to have it queued up and if 
necessary synchronized with other pending code.
-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/
