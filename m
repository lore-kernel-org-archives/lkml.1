Return-Path: <linux-kernel-owner+w=401wt.eu-S1767364AbXCIQ2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767364AbXCIQ2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767363AbXCIQ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:28:44 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37282 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767364AbXCIQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:28:43 -0500
Date: Fri, 9 Mar 2007 10:28:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Arnd Bergmann <arnd@arndb.de>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
Subject: Re: [PATCH 7/7] revoke: wire up s390 system calls
Message-ID: <20070309162839.GE5948@sergelap.austin.ibm.com>
References: <Pine.LNX.4.64.0703091016340.32320@sbz-30.cs.Helsinki.FI> <200703091611.09737.arnd@arndb.de> <1173454580.14888.1.camel@localhost> <45F18016.4030502@cs.helsinki.fi> <1173456737.14888.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173456737.14888.3.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Martin Schwidefsky (schwidefsky@de.ibm.com):
> On Fri, 2007-03-09 at 17:41 +0200, Pekka Enberg wrote:
> > Martin Schwidefsky wrote:
> > > Yes, please put me or Heiko on CC if you add system calls to s390.
> > 
> > Ok, sorry about that. I would expect akpm to send it to you guys though 
> > whenever revoke graduates from -mm and not merge it to mainline.
> 
> Yes, but nobody is perfect. Even Andrew sometimes forgets to add people
> to CC who should know about "stuff". It would be nice if the CC-line is
> added from the start.

Sorry, I should have cc:d you when I sent my testing patch to Pekka.

-serge
