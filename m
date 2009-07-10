Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZGJI7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZGJI7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZGJI6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:58:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35029 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZGJI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:58:54 -0400
Subject: Re: [PATCH Resend2] Remove 'SBC8240 Wind River' Device Driver Code
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: David Woodhouse <dwmw2@infradead.org>
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
In-Reply-To: <1247216007.29541.2.camel@macbook.infradead.org>
References: <20090701135247.27488.10776.sendpatchset@subratamodak.linux.ibm.com>
	 <1246846628.5743.2.camel@subratamodak.linux.ibm.com>
	 <1247205588.20721.353.camel@localhost.localdomain>
	 <1247206539.6630.0.camel@subratamodak.linux.ibm.com>
	 <4A56DD51.5040703@gmail.com>
	 <1247209961.6630.3.camel@subratamodak.linux.ibm.com>
	 <1247210095.20721.362.camel@localhost.localdomain>
	 <1247215625.6630.6.camel@subratamodak.linux.ibm.com>
	 <1247216007.29541.2.camel@macbook.infradead.org>
Content-Type: text/plain
Organization: IBM
Date: Fri, 10 Jul 2009 14:28:44 +0530
Message-Id: <1247216324.6630.10.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 09:53 +0100, David Woodhouse wrote:
> On Fri, 2009-07-10 at 14:17 +0530, Subrata Modak wrote:
> > Is it possible to get this patch through and before 2.6.31 stable is
> > released ?
> 

Hi David,

> Hm, I was ignoring this until I was sure all the last-minute fixes for
> 2.6.31 were out of the way; I was planning to submit it for 2.6.32.
> 
> Do we really need to submit it for 2.6.31? It's not a regression, is it?
> It's been like this for _ages_.

True. But it gives annoying build fails on randconfig next trees. And
we(Sachin & myself) has been reporting it from March/April. If you feel
there is still room to be pushed to 2.6.31, then please do it. Else,
2.6.32 will be fine. Thanks for your support.

Regards--
Subrata

> 

