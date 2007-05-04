Return-Path: <linux-kernel-owner+w=401wt.eu-S1161886AbXEDS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161886AbXEDS56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161653AbXEDS56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:57:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161886AbXEDS55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:57:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: incoming
In-Reply-To: Andrew Morton's message of  Friday, 4 May 2007 09:14:34 -0700 <20070504091434.106ad04d.akpm@linux-foundation.org>
X-Shopping-List: (1) Interlocking docks
   (2) Rain-making rice yies
   (3) Evangelical Miltonic laxatives
   (4) Simultaneous dogs
   (5) Raucous fibrous hair
Message-Id: <20070504185721.3CB7C1800A0@magilla.sf.frob.com>
Date: Fri,  4 May 2007 11:57:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah.  The patch affects security code, but it doesn't actually address any
> insecurity.  I didn't think it was needed for -stable?

I would not recommend it for -stable.  
It is an ABI change for the case of a security refusal.


Thanks,
Roland
