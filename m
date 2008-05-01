Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYEABbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYEABbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYEABa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:30:58 -0400
Received: from gw.goop.org ([64.81.55.164]:33323 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYEABa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:30:57 -0400
Message-ID: <48191D43.5010305@goop.org>
Date: Wed, 30 Apr 2008 18:30:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Willy Tarreau <w@1wt.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>   And I think publicly announced git trees and -mm and linux-next are 
>   great partly because they end up doing that same thing. I heartily 
>   encourage submaintainers to always Cc: linux-kernel when they send me a 
>   "please pull" request - I don't know if anybody else ever really pulls 
>   that tree, but I do think that it's very healthy to write that message 
>   and think of it as a publication event. ]
>   

And, ideally, they would have posted the changes as patches to the list 
for review anyway, so there shouldn't be anything surprising in that pull...

    J
