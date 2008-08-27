Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYH0UtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYH0UtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYH0UtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:49:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43702 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYH0UtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:49:10 -0400
Date: Wed, 27 Aug 2008 15:48:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
Message-ID: <20080827204853.GA4189@us.ibm.com>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu> <1219437422.20559.146.camel@nimitz> <48B0F449.2000006@cs.columbia.edu> <1219768406.8680.17.camel@nimitz> <48B49C61.1040003@cs.columbia.edu> <1219851696.8680.67.camel@nimitz> <20080827203427.GA1158@us.ibm.com> <1219869510.8680.90.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219869510.8680.90.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Wed, 2008-08-27 at 15:34 -0500, Serge E. Hallyn wrote:
> > (Or, is that too much effort required on your part to try and
> > cherrypick bits of Oren's changes back into your tree?)
> 
> That would probably work as long as Oren is working on top of what I
> have.  It's going to be a lot harder if I have to repeat the same
> break-out process for each iteration of Oren's patches, though.
> 
> -- Dave

If Oren's purpose is not quite to create a upstreamable patchset,
then it would make more sense for him to keep a git tree and
put new patches on top of his existing ones (within reaason as he
rebases).  Then you'd at least be able to trivially look at the latest
deltas.

-serge
