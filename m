Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbYDVO14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbYDVO14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYDVO1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:27:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26469 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbYDVO1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:27:44 -0400
Date: Tue, 22 Apr 2008 16:27:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Kyle McMartin <kyle@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 9/11] parisc: convert to generic helpers for IPI  function calls
Message-ID: <20080422142738.GH12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-10-git-send-email-jens.axboe@oracle.com> <20080422140914.GD19802@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422140914.GD19802@phobos.i.cabal.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Kyle McMartin wrote:
> On Tue, Apr 22, 2008 at 09:57:35AM +0200, Jens Axboe wrote:
> > This converts mips to use the new helpers for smp_call_function() and
> > friends, and adds support for smp_call_function_single(). Not tested,
> > not even compiled.
> > 
> 
> At first glance, this looks alright. +1 from me.

Is that an official parisc ack? :-)

And I'll make sure the patch comment matches... I wish that Andrews xb
compiler collection had all the supported archs covered.

-- 
Jens Axboe

