Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYEAB5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYEAB5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYEAB5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:57:31 -0400
Received: from [207.36.208.214] ([207.36.208.214]:54958 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbYEAB5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:57:30 -0400
Message-ID: <48192376.7060108@garzik.org>
Date: Wed, 30 Apr 2008 21:57:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <18457.219.995207.136771@cargo.ozlabs.ibm.com>
In-Reply-To: <18457.219.995207.136771@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> By the way, if you do want to make that rule, then there's a really
> easy way to do it - just pull linux-next, and make that one pull be
> the entire merge window. :)

That's a unique and interesting idea...

	Jeff


