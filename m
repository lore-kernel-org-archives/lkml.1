Return-Path: <linux-kernel-owner+w=401wt.eu-S1764848AbZDHMof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764848AbZDHMof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZDHMoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:44:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZDHMoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:44:24 -0400
Date: Wed, 8 Apr 2009 08:44:11 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Lee Revell <rlrevell@joe-job.com>
cc: Ric Wheeler <ricwheeler@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
In-Reply-To: <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904080839200.28196@hs20-bc2-1.build.redhat.com>
References: <20090324150517.GX27476@kernel.dk> 
 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com> 
 <20090326084205.GG27476@kernel.dk>  <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
  <20090331104933.GJ5178@kernel.dk>  <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
  <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com> 
 <20090405012839.GF7553@mit.edu> <49D89C06.1060700@gmail.com>
 <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Apr 2009, Lee Revell wrote:

> On Sun, Apr 5, 2009 at 7:54 AM, Ric Wheeler <ricwheeler@gmail.com> wrote:
> > One thing to point out here is that there are a lot of "servers" in high end
> > data centers that do not have UPS backup. Those racks full of 1U and 2U
> > boxes that are used to make "grids", "clouds" and so on often are built with
> > as much gear as you can stuff in a rack - no batteries or UPS to be seen, so
> > they are really quite similar to the normal desktop or home systems that we
> > normally run at home :-)
> 
> These days even bargain basement data centers provide UPS functionality for
> you, via generator backup and A/B power.

I have seen an installation having generator backup, but with another 
serious flaw --- if someone plugged a computer causing short-circuit, it 
turned off the circuit breaker for the whole rack :)

Mikulas

> Lee
