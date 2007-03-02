Return-Path: <linux-kernel-owner+w=401wt.eu-S965990AbXCFS2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965990AbXCFS2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965989AbXCFS23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:28:29 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39057 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291AbXCFS2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:28:25 -0500
Date: Thu, 1 Mar 2007 17:26:58 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Christoph Hellwig <hch@infradead.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 26/26] Xen-paravirt_ops: Add the Xen virtual network device driver.
Message-ID: <20070302012658.GB10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232529.648076372@goop.org> <20070301164214.4a40bc59@freekitty> <20070302012102.GA15252@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302012102.GA15252@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> Actually the right way to do it is in userspace, as all clustering
> solutions do.  That's whay everyone told the Xen folks by the just
> refuse to rip this junk out.

I'm ripping it out.
