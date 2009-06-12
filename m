Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbZFLKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbZFLKDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZFLKDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:03:41 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:1997 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753501AbZFLKDk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:03:40 -0400
X-SpamScore: -41
X-BigFish: VPS-41(z21eWz1432R98dR4015L1805M873fizz1202hzzz32i6bh17ch6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KL4ELX-02-4ZA-01
Date: Fri, 12 Jun 2009 12:03:08 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD64 EDAC module for 2.6.31
Message-ID: <20090612100308.GA4403@aftab>
References: <20090611103705.GC15454@aftab> <20090612080323.GA14669@liondog.tnic> <20090612181022.8accf95b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090612181022.8accf95b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 12 Jun 2009 10:03:12.0144 (UTC) FILETIME=[FEC5A900:01C9EB44]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 06:10:22PM +1000, Stephen Rothwell wrote:
> Hi Borislav,
> 
> On Fri, 12 Jun 2009 10:03:23 +0200 Borislav Petkov <petkovbb@googlemail.com> wrote:
> >
> > now that amd64 EDAC is upstream, I've removed the fox-next branch since
> > the next patch series is not ready yet.
> > 
> > What is actually the proper way to let you know that I don't have any
> > more patches for linux-next right now and that you don't have to pull
> > from my repo for now?
> 
> Just set the for-next branch to point somewhere in Linus' tree (where it
> was would be fine if that is what Linus' merged from you).  That way I
> can still try to fetch it each day and when you have new stuff, you can
> just put it there without bothering to remember to tell me anything.

Thanks, done.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

