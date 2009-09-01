Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZIAIuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZIAIuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZIAIuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:50:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:14525 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZIAIuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:50:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182702966"
Date: Tue, 1 Sep 2009 15:55:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Chris Wright <chrisw@redhat.com>, Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH] pagemap: document KPF_KSM and show it in page-types
Message-ID: <20090901075559.GA1446@localhost>
References: <20090808173900.GA21009@feather> <20090812065107.GA16363@localhost> <20090831135720.5E53.A69D9226@jp.fujitsu.com> <20090831065659.GA18039@localhost> <20090831071425.GA26634@localhost> <20090831071702.GB26634@localhost> <20090831083911.715b630b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831083911.715b630b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 11:39:11PM +0800, Randy Dunlap wrote:
> > +21. KSM
> > +    identical memory pages dynamicly shared between one or more processes
> 
>                               dynamically

Corrected, thanks!
