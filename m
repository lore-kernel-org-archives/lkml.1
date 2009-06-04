Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZFDT2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZFDT2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZFDT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:28:17 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:33851 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZFDT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:28:16 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 14:23:32 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090604174059.GB9823@prithivi.gnumonks.org> <200906041312.45847.lkml@morethan.org>
In-Reply-To: <200906041312.45847.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041423.35191.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Michael S. Zick wrote:
> On Thu June 4 2009, Harald Welte wrote:
> > On Thu, Jun 04, 2009 at 11:21:28AM -0500, Michael S. Zick wrote:
> > 
> 
> @Linus - -
> The Debian/Ubuntu distribution kernels require irqpoll (2.6.28+) -
> I took that out very early in my testing, when that problem got fixed -
> I will also try putting that back in, it might be needed for
> some of its side-effects on the processor/chipset.
> 

It looks like I stopped using irqpoll on 4/10 (-rc1)
http://forum.netbookuser.com/viewtopic.php?pid=6708#p6708

Am re-testing the "virgin" kernel build with both command options now:
http://forum.netbookuser.com/viewtopic.php?pid=7037#p7037

Will post if it has less than 6 months of up-time.  ;)

Mike

