Return-Path: <linux-kernel-owner+w=401wt.eu-S939920AbXGSSKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939920AbXGSSKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbXGSSKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:10:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58077 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006AbXGSSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:10:31 -0400
Date: Thu, 19 Jul 2007 13:10:29 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Christian Ehrhardt <lk@c--e.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719181029.GA3503@sergelap.austin.ibm.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <1184864070.2694.3.camel@laptopd505.fenrus.org> <20070719171913.GA1275@sergelap.austin.ibm.com> <1184868021.2694.6.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184868021.2694.6.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arjan van de Ven (arjan@infradead.org):
> 
> > 
> > :)
> > 
> > Actually, given that when lsm was being introduced, lsm seemed to
> > improve performance overall, have you taken any measurements to show
> > that this is actually the case?  Of course it makes sense that it would,
> > but witjout measurements we do not know.
> 
> SuSE did a bunch of measurement I think a year ago and they showed a
> several percent performance increase with a hack similar to the proposed
> next step..

Very good.

-serge
