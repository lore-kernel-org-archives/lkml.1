Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYBOUc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYBOUc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYBOUcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:32:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50977 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbYBOUcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:32:19 -0500
Date: Fri, 15 Feb 2008 21:32:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Linux Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: arch/x86/mm/ioremap unification grew by 10x
Message-ID: <20080215203228.GA4295@uranus.ravnborg.org>
References: <1203107155.12383.230.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203107155.12383.230.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 02:25:54PM -0600, Matt Mackall wrote:
> In 2.6.24 defconfig, my build stats show ioremap_32.o was 1.8k. In
> 2.6.25-rc1, the unified ioremap.o is 20.8k.

Just an observation - 17 commits touches said file after
the unification (at least in latest -linus).

	Sam
