Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXGSMm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXGSMm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbXGSMmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:42:50 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:43209 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753599AbXGSMmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:42:49 -0400
X-YMail-OSG: 3VOB8hMVM1nnWUfHoCaA5S6xcI66yTtvNwWU3BNcqYdqY5JRebB93Kn2mFtUZpxzg5QgTVP1Pg--
Date: Thu, 19 Jul 2007 07:42:44 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christian Ehrhardt <lk@c--e.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719124244.GA7219@vino.hallyn.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <Line.LNX.4.64.0707190832290.4303@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0707190832290.4303@d.namei>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Thu, 19 Jul 2007, Serge E. Hallyn wrote:
> 
> > If we could get a few (non-afilliated :) people who work with
> > customers in the security field to tell us whether this is being
> > used, that would be very helpful.  Not sure how to get that.
> 
> The mainline kernel does not cater to out of tree code.

(Must... resist...)

> > Or we just apply the patch and see who yells  :)
> 
> 
> It's already pretty clear.

I doubt anyone not on lkml or linux-security-module has heard of this.

So we'll see.

(I was, obviously, talking about end-users)

-serge
