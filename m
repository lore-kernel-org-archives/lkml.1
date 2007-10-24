Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbXJXJAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbXJXJAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXJXJAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:00:30 -0400
Received: from ns.firmix.at ([62.141.48.66]:4855 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXJXJA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:00:26 -0400
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
From: Bernd Petrovitsch <bernd@firmix.at>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Roland Dreier <rdreier@cisco.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>
In-Reply-To: <20071023193526.GY4000@csclub.uwaterloo.ca>
References: <471CDC5E.4010300@linux.intel.com>
	 <20071022114001.40470c15.akpm@linux-foundation.org>
	 <20071023150429.GK4003@csclub.uwaterloo.ca>
	 <20071023092333.39982483@laptopd505.fenrus.org>
	 <20071023180547.GL4003@csclub.uwaterloo.ca> <adar6jl6685.fsf@cisco.com>
	 <20071023193526.GY4000@csclub.uwaterloo.ca>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 24 Oct 2007 11:00:09 +0200
Message-Id: <1193216409.1058.14.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.311 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.311 required=5
X-Spam-Score: -2.311 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2007-10-23 at 15:35 -0400, Lennart Sorensen wrote:
> On Tue, Oct 23, 2007 at 11:22:50AM -0700, Roland Dreier wrote:
> > It's not a hard experiment to do.
> > 
> > The answer is:
> > 
> >     warning: suggest parentheses around assignment used as truth value
> 
> A warning is not an error.  It won't abort the compile.

Add "-Werror".

> The warning (which I don't remember gcc doing in the past) is a nice
> idea though.

That's the case since many years - I don't remember how long.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


