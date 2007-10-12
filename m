Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbXJLCyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbXJLCyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXJLCyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:54:22 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:47319 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbXJLCyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:54:21 -0400
Date: Fri, 12 Oct 2007 11:53:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, paulus@ozlabs.org,
       kyle@parisc-linux.org, grundler@parisc-linux.org
Subject: Re: [PATCH 1/2] bug.h: Introduce HAVE_ARCH_WARN
Message-ID: <20071012025355.GA17704@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, paulus@ozlabs.org, kyle@parisc-linux.org,
	grundler@parisc-linux.org
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
sh bits are fine.

Acked-by: Paul Mundt <lethal@linux-sh.org>
