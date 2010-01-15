Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab0AOFix (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 00:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061Ab0AOFiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 00:38:52 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:38714 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0AOFiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 00:38:50 -0500
Message-ID: <4B4FFF51.6020803@gmail.com>
Date: Fri, 15 Jan 2010 06:38:25 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: James Kosin <JKosin@intcomgrp.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: at91_ether.c - Allow transmitter interrupt to
 be handled first in ISR
References: <3DBBD805E3BA064A87F551C0E8BD36740289748A@MAILSRV.intcomgrp.com> <20100113.173253.223656114.davem@davemloft.net> <3DBBD805E3BA064A87F551C0E8BD367402897539@MAILSRV.intcomgrp.com>
In-Reply-To: <3DBBD805E3BA064A87F551C0E8BD367402897539@MAILSRV.intcomgrp.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 15 Jan 2010 06:38:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/01/2010 21:28, James Kosin a écrit :
> Thanks David,
> 
> I'm checking out the latest git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
> With git now...
> 
> A few items:
> 	a)  Is it OK to use git-diff to build a patch file?  Or does everyone still prefer
> 	    diff?

If you cook your patches using a git tree, git diff is very fine to send official patches.

> 
> 	b)  I'm going to try and test also; since, I do have an active platform I
> 	    can test on.  Are there any other developers using the ARM that may be able
> 	    to provide some feedback?  Eric Dumazet had some interesting comments
> 	    but, none of the original people in the file are around anymore I'm afraid.
> 	    That or they really don't want to be contacted.

If you can test patches, and other dev can review them, they can find their way in kernel,
dont worry :)
