Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbYEABjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbYEABjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYEABjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:39:35 -0400
Received: from gw.goop.org ([64.81.55.164]:48337 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYEABje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:39:34 -0400
Message-ID: <48191F47.7050706@goop.org>
Date: Wed, 30 Apr 2008 18:39:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: david@lang.hm, Chris Shoemaker <c.shoemaker@cox.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200805010023.32213.rjw@sisk.pl> <alpine.DEB.1.10.0804301528250.7807@asgard> <200805010145.39373.rjw@sisk.pl> <alpine.DEB.1.10.0804301654200.7807@asgard> <20080501000131.GB1559@pe.Belkin> <alpine.DEB.1.10.0804301713040.7807@asgard> <alpine.LFD.1.10.0804301715560.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301715560.5994@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> That's what we largely had with the Xen merge, for example. A lot of the 
> code had been around for basically _forever_, and the people involved in 
> reviewing it got really tired of it, and there was no way in *hell* a new 
> person would ever start reviewing the huge backlog. Once it is massive, 
> it's just too massive.
>   

Heh.  The Xen code in the kernel now is a complete rewrite, with only 
trace elements from the original patchset.  And yes, that's partly 
because the original patches were unreviewable.

    J
