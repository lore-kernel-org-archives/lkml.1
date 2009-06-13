Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZFMAFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZFMAFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZFMAFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:05:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37135
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbZFMAFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:05:12 -0400
Date: Fri, 12 Jun 2009 17:05:14 -0700 (PDT)
Message-Id: <20090612.170514.127460725.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: randy.dunlap@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       mchan@broadcom.com, torvalds@linux-foundation.org
Subject: Re: -git tree build failure in drivers/net/cnic.c: undefined
 reference to `ip6_route_output'
From: David Miller <davem@davemloft.net>
In-Reply-To: <1244851393.26552.1.camel@mulgrave.site>
References: <4A32A1E4.8080708@oracle.com>
	<20090612.165108.110857018.davem@davemloft.net>
	<1244851393.26552.1.camel@mulgrave.site>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 13 Jun 2009 00:03:13 +0000

> On Fri, 2009-06-12 at 16:51 -0700, David Miller wrote:
>> I was hoping the scsi folks, or Linus directly, would pick this up.
> 
> I can, but my first tree's just gone ... the next one won't be going
> until nearer the merge window.
> 
>> But I can take it in too if it slips through the cracks.
> 
> That's fine by me too ... If you had a net tree ready, that would be
> great ... if not, I'll add it to the next SCSI tree to go.

I intend to make my networking pull request late Saturday, or mid-day
Sunday, PST timezone.

So you're taking it would expedite the fix going in potentially.
