Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYG2UAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYG2UAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYG2UAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:00:24 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43920 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYG2UAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:00:23 -0400
Date: Tue, 29 Jul 2008 21:00:08 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080729200006.GA25885@shareable.org>
References: <20080729154520.728594017@free-electrons.com> <20080729154747.872888047@free-electrons.com> <20080729181751.GA24924@parisc-linux.org> <1217357875.15724.167.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217357875.15724.167.camel@calx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> The typical embedded NFS-based devices are NAS servers and media players
> and are going to be more concerned about things like page cache
> balancing.

Oh, those.

It would be really annoying to buy a home NAS and find it doesn't
support NFS locks or SMB oplocks.  NASes are vaguely useful for more
than one computer in the house at the same time.

That said, I bought a big, expensive one, found it far too slow for my
needs, send it back for a refund and bought a portable cheap USB disk
which had *so* much higher performance.  The convenience of serving
multiple machines just wasn't worth the lousy performance.

-- Jamie
