Return-Path: <linux-kernel-owner+w=401wt.eu-S2993113AbXCIPgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993113AbXCIPgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993121AbXCIPgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:36:40 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:26262 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993113AbXCIPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:36:39 -0500
Subject: Re: [PATCH 7/7] revoke: wire up s390 system calls
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
In-Reply-To: <200703091611.09737.arnd@arndb.de>
References: <Pine.LNX.4.64.0703091016340.32320@sbz-30.cs.Helsinki.FI>
	 <200703091611.09737.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Fri, 09 Mar 2007 16:36:20 +0100
Message-Id: <1173454580.14888.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 16:11 +0100, Arnd Bergmann wrote:
> > Make revokeat and frevoke system calls available to user-space on s390.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Looks good to me, but you really should through Martin, since he
> has an overview of what syscall numbers may already be assigned
> some another patch he has queued up.

Yes, please put me or Heiko on CC if you add system calls to s390.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


