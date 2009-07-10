Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZGJIxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZGJIxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZGJIxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:53:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:45666 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZGJIxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:53:39 -0400
Subject: Re: [PATCH Resend2] Remove 'SBC8240 Wind River' Device Driver Code
From: David Woodhouse <dwmw2@infradead.org>
To: subrata@linux.vnet.ibm.com
Cc: dedekind@infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd@lists.infradead.org, carolyn.j.smith@exgate.tek.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Jim Cromie <jim.cromie@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       linux-next <linux-next@vger.kernel.org>,
       Scott Wood <scottwood@freescale.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1247215625.6630.6.camel@subratamodak.linux.ibm.com>
References: <20090701135247.27488.10776.sendpatchset@subratamodak.linux.ibm.com>
	 <1246846628.5743.2.camel@subratamodak.linux.ibm.com>
	 <1247205588.20721.353.camel@localhost.localdomain>
	 <1247206539.6630.0.camel@subratamodak.linux.ibm.com>
	 <4A56DD51.5040703@gmail.com>
	 <1247209961.6630.3.camel@subratamodak.linux.ibm.com>
	 <1247210095.20721.362.camel@localhost.localdomain>
	 <1247215625.6630.6.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 09:53:27 +0100
Message-Id: <1247216007.29541.2.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 14:17 +0530, Subrata Modak wrote:
> Is it possible to get this patch through and before 2.6.31 stable is
> released ?

Hm, I was ignoring this until I was sure all the last-minute fixes for
2.6.31 were out of the way; I was planning to submit it for 2.6.32.

Do we really need to submit it for 2.6.31? It's not a regression, is it?
It's been like this for _ages_.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

