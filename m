Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbXEEQNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbXEEQNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXEEQNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:13:44 -0400
Received: from ozlabs.org ([203.10.76.45]:58647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbXEEQNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:13:42 -0400
Subject: Re: [patch 25/29] xen: Add the Xen virtual network device driver.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Stephen Hemminger <shemminge@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <20070505091624.GA8890@infradead.org>
References: <20070504232051.411946839@goop.org>
	 <20070504232121.492190579@goop.org>  <20070505091624.GA8890@infradead.org>
Content-Type: text/plain
Date: Sat, 05 May 2007 20:16:50 +1000
Message-Id: <1178360210.12284.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 10:16 +0100, Christoph Hellwig wrote:
> I wish people would have listened to me back then and made the
> description part of the modular_param statement..

Sometimes we weary of change.  However, come up with a decent name and
implement it and we can deprecate module_param() by say... 2012?

Cheers,
Rusty.


