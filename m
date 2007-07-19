Return-Path: <linux-kernel-owner+w=401wt.eu-S940329AbXGSRe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940329AbXGSRe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935280AbXGSRem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:34:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:48712 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbXGSRel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:34:41 -0400
Date: Thu, 19 Jul 2007 10:34:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Serge E. Hallyn" <serge@hallyn.com>, Christian Ehrhardt <lk@c--e.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719173407.GA3672@sequoia.sous-sol.org>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <1184864070.2694.3.camel@laptopd505.fenrus.org> <20070719171913.GA1275@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719171913.GA1275@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> Actually, given that when lsm was being introduced, lsm seemed to
> improve performance overall, have you taken any measurements to show
> that this is actually the case?  Of course it makes sense that it would,
> but witjout measurements we do not know.

Yes, it does.  I have measured it as have others (esp. after Kurt
Garloff pointed out issues on ia64).

thanks,
-chris
