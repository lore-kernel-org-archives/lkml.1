Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXC3Tgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXC3Tgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXC3Tgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:36:41 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:30454 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXC3Tgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:36:41 -0400
Date: Fri, 30 Mar 2007 21:36:38 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com
Subject: Re: [PATCH 8/9] clocksource: s390 initialize list value
Message-ID: <20070330193638.GC13240@osiris.ibm.com>
References: <20070330184541.583153763@mvista.com> <20070330184616.107636073@mvista.com> <20070330190905.GB13240@osiris.ibm.com> <1175282358.12252.179.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175282358.12252.179.camel@imap.mvista.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 12:19:18PM -0700, Daniel Walker wrote:
> On Fri, 2007-03-30 at 21:09 +0200, Heiko Carstens wrote:
> > On Fri, Mar 30, 2007 at 11:45:49AM -0700, Daniel Walker wrote:
> > > Update arch/s390 with list initialization.
> > > 
> > > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
[...]
> > Why? This doesn't fix anything...
> 
> It's needed for patch 9/9 in the series.

Then maybe your patch description should reflect that?
If this gets merged as a seperate patch and somebody checks the git
history of arch/s390 and sees this patch... how could he know what
this is good for?
Does it fix a bug? Needed by any feature? Or...?
