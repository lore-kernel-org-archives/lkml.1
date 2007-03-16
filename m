Return-Path: <linux-kernel-owner+w=401wt.eu-S965984AbXCPWSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965984AbXCPWSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965987AbXCPWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:18:31 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34522 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965984AbXCPWSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:18:30 -0400
Date: Fri, 16 Mar 2007 15:18:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 03/26] Xen-paravirt_ops: use paravirt_nop to consistently mark no-op operations
Message-ID: <20070316221834.GQ10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232526.261284776@goop.org> <20070316094432.GU23174@elte.hu> <45FAE560.10401@goop.org> <20070316194904.GO10574@sequoia.sous-sol.org> <45FAF77A.8010607@goop.org> <20070316215916.GP10574@sequoia.sous-sol.org> <45FB15E8.4080406@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FB15E8.4080406@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Chris Wright wrote:
> > I mean like this (bunch of work, for a type check that we're really ignoring
> > anwyay, but this is the idea...)
> 
> Oh, I see.  I think this is the best argument yet for the current
> arrangement...

Heh, like I said it's a bunch of work for literally nothing ;-)
