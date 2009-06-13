Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZFMOht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZFMOht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbZFMOhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:37:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44165 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbZFMOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:37:40 -0400
Subject: Re: -git tree build failure in drivers/net/cnic.c: undefined
 reference to `ip6_route_output'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       mchan@broadcom.com, torvalds@linux-foundation.org
In-Reply-To: <20090612.170514.127460725.davem@davemloft.net>
References: <4A32A1E4.8080708@oracle.com>
	 <20090612.165108.110857018.davem@davemloft.net>
	 <1244851393.26552.1.camel@mulgrave.site>
	 <20090612.170514.127460725.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 09:37:37 -0500
Message-Id: <1244903857.5323.11.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 17:05 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sat, 13 Jun 2009 00:03:13 +0000
> 
> > On Fri, 2009-06-12 at 16:51 -0700, David Miller wrote:
> >> I was hoping the scsi folks, or Linus directly, would pick this up.
> > 
> > I can, but my first tree's just gone ... the next one won't be going
> > until nearer the merge window.
> > 
> >> But I can take it in too if it slips through the cracks.
> > 
> > That's fine by me too ... If you had a net tree ready, that would be
> > great ... if not, I'll add it to the next SCSI tree to go.
> 
> I intend to make my networking pull request late Saturday, or mid-day
> Sunday, PST timezone.
> 
> So you're taking it would expedite the fix going in potentially

OK, I've added it to my patch queue.

James

