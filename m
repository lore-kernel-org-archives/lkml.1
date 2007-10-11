Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbXJKRU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbXJKRU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXJKRUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:20:51 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:50139 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXJKRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:20:51 -0400
Date: Thu, 11 Oct 2007 13:20:48 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, paulus@ozlabs.org,
       lethal@linux-sh.org, kyle@parisc-linux.org, grundler@parisc-linux.org
Subject: Re: [PATCH 1/2] bug.h: Introduce HAVE_ARCH_WARN
Message-ID: <20071011172048.GA18097@fattire.cabal.ca>
References: <20071011171211.GB10877@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011171211.GB10877@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 12:12:11PM -0500, Olof Johansson wrote:
> HAVE_ARCH_WARN is used to determine if an arch already has a __WARN()
> macro, or if a generic one is needed.
> 
> With this, some of the arch-specific WARN_ON() implementations can be
> made common instead (see follow-up patch for powerpc).
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 

ack parisc hunk (obviously :)

cheers,
	kyle
