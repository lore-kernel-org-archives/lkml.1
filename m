Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZBOK10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZBOK10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZBOK1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:27:17 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:46203 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZBOK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:27:16 -0500
Date: Sun, 15 Feb 2009 15:57:08 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gene Heskett <gene.heskett@verizon.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 10/10] Sample HW breakpoint over kernel data address
Message-ID: <20090215102708.GA4154@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090213145301.GA31546@in.ibm.com> <20090213145943.GJ32064@in.ibm.com> <200902131138.41496.gene.heskett@verizon.net> <20090214164456.GA5511@in.ibm.com> <20090214224341.GA20477@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214224341.GA20477@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 11:43:41PM +0100, Ingo Molnar wrote:
> 
> * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> 
> > On Fri, Feb 13, 2009 at 11:38:41AM -0500, Gene Heskett wrote:
> > > On Friday 13 February 2009, K.Prasad wrote:
> > > 
> > > A whole patch series sent as private email, but which should have been 
> > > submitted to lkml?  Please configure your email agent correctly.
> > 
> > I realised that a little late and hence bounced the mails to LKML. It
> > was an oversight on my part, will be more careful henceforth.
> 
> Hm, bouncing is not necessarily a good idea, as followups will not have
> lkml Cc:-ed. I'd suggest a repost, with lkml added.
> 
> 	Ingo

Sure. I'm re-posting the patches with LKML included in the recipient.

Thanks,
K.Prasad

