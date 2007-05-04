Return-Path: <linux-kernel-owner+w=401wt.eu-S1423079AbXEDTaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423079AbXEDTaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423097AbXEDTaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:30:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423079AbXEDTaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:30:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Greg KH <greg@kroah.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: incoming
In-Reply-To: Greg KH's message of  Friday, 4 May 2007 12:24:07 -0700 <20070504192407.GA32235@kroah.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070504192944.7D5041800A0@magilla.sf.frob.com>
Date: Fri,  4 May 2007 12:29:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ABI changes are not a problem for -stable, so don't let that stop anyone
> :)

In fact this is the harmless sort (changes only the error code of a
failure case) that might actually go in if there were any important
reason.  But the smiley stands.


Thanks,
Roland
