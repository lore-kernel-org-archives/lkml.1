Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXLWUNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXLWUNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXLWUNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:13:04 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:41323 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbXLWUNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:13:02 -0500
Date: Sun, 23 Dec 2007 22:13:00 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: More verizon problems
Message-ID: <20071223201300.GL28168@mea-ext.zmailer.org>
References: <200712231430.50493.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712231430.50493.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 02:30:50PM -0500, Gene Heskett wrote:
> Date: Sun, 23 Dec 2007 14:30:50 -0500
> From: Gene Heskett <gene.heskett@gmail.com>
> Subject: More verizon problems
> To: linux-kernel@vger.kernel.org
> Content-type: text/plain; charset=iso-8859-1
> 
> Resend, with more odd data from fetchmail.log appended.

Looking at that log..

 
> PS:  From my fetchmail.log since I turned on the -v -v options an hour ago:
> --------------
> fetchmail: 6.3.6 querying pop.gmail.com (protocol POP3) at Sun 23 Dec 2007 
> 02:20:56 PM EST: poll started
> fetchmail: Trying to connect to 209.85.133.109/995...connected.
> fetchmail: Issuer Organization: Equifax
> fetchmail: Unknown Issuer CommonName
> fetchmail: Server CommonName: pop.gmail.com
> fetchmail: pop.gmail.com key fingerprint: 44:A8:E9:2C:FB:A9:7E:6D:F9:DB:F3:62:B2:9E:F1:A9

This looks like correct and genuine gmail service.

> fetchmail: POP3< +OK Gpop ready for requests from 72.65.67.83 b11pf2510187ana.0
> fetchmail: POP3> CAPA
> fetchmail: POP3< +OK Capability list follows
> fetchmail: POP3< USER
> fetchmail: POP3< RESP-CODES
> fetchmail: POP3< EXPIRE 0
> fetchmail: POP3< LOGIN-DELAY 300
> fetchmail: POP3< X-GOOGLE-VERHOEVEN
> fetchmail: POP3< UIDL
> fetchmail: POP3< .
> fetchmail: POP3> USER gene.heskett
> fetchmail: POP3< +OK send PASS
> fetchmail: POP3> PASS *
> fetchmail: POP3< +OK Welcome.
> fetchmail: selecting or re-polling default folder
> fetchmail: POP3> STAT
> fetchmail: POP3< +OK 0 0
> fetchmail: No mail for gene.heskett at pop.gmail.com
> fetchmail: POP3> QUIT
> fetchmail: POP3< +OK Farewell.
> fetchmail: 6.3.6 querying pop.gmail.com (protocol POP3) at Sun 23 Dec 2007 02:20:57 PM EST: poll completed
> fetchmail: not swapping UID lists, no UIDs seen this query
> fetchmail: Query status=1 (NOMAIL)
> -----------
> 
> about 30 of those, there is never any mail for me at gmail.
> 
> Has my subscription info gotten contaminated somehow?

re-forward at gmail to verizon ?

> sorry for the noise folks, but this is a classic case of me and road rage.

I try to avoid that.  Gives others an illusion of me being smarter
than I am in reality...  :-)

> -- 
> Cheers, Gene

/Matti Aarnio
