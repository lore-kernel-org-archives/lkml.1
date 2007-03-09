Return-Path: <linux-kernel-owner+w=401wt.eu-S1767348AbXCIQMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767348AbXCIQMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767345AbXCIQMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:12:19 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:27487 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767348AbXCIQMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:12:18 -0500
Subject: Re: [PATCH 7/7] revoke: wire up s390 system calls
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
In-Reply-To: <45F18016.4030502@cs.helsinki.fi>
References: <Pine.LNX.4.64.0703091016340.32320@sbz-30.cs.Helsinki.FI>
	 <200703091611.09737.arnd@arndb.de> <1173454580.14888.1.camel@localhost>
	 <45F18016.4030502@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Fri, 09 Mar 2007 17:12:17 +0100
Message-Id: <1173456737.14888.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 17:41 +0200, Pekka Enberg wrote:
> Martin Schwidefsky wrote:
> > Yes, please put me or Heiko on CC if you add system calls to s390.
> 
> Ok, sorry about that. I would expect akpm to send it to you guys though 
> whenever revoke graduates from -mm and not merge it to mainline.

Yes, but nobody is perfect. Even Andrew sometimes forgets to add people
to CC who should know about "stuff". It would be nice if the CC-line is
added from the start.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


