Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbYBOVW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbYBOVW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbYBOVWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:22:19 -0500
Received: from waste.org ([66.93.16.53]:60411 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951AbYBOVWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:22:18 -0500
Subject: Re: arch/x86/mm/ioremap unification grew by 10x
From: Matt Mackall <mpm@selenic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080215203228.GA4295@uranus.ravnborg.org>
References: <1203107155.12383.230.camel@cinder.waste.org>
	 <20080215203228.GA4295@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 15:21:28 -0600
Message-Id: <1203110488.12383.231.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 21:32 +0100, Sam Ravnborg wrote:
> On Fri, Feb 15, 2008 at 02:25:54PM -0600, Matt Mackall wrote:
> > In 2.6.24 defconfig, my build stats show ioremap_32.o was 1.8k. In
> > 2.6.25-rc1, the unified ioremap.o is 20.8k.
> 
> Just an observation - 17 commits touches said file after
> the unification (at least in latest -linus).

Correction: those numbers should be halved. So we're going from .9k to
10.4k.

-- 
Mathematics is the supreme nostalgia of our time.

