Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbXF3Qj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbXF3Qj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 12:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXF3QjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 12:39:20 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:41543 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbXF3QjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 12:39:19 -0400
Date: Sat, 30 Jun 2007 18:39:18 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] fbdev: uvesafb
Message-ID: <20070630163918.GG3838@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070623104920.GA12623@spock.one.pl> <20070626104241.GR8547@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070626104241.GR8547@earth.li>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:42:41AM +0100, Jonathan McDowell wrote:

> Have you considered using libx86[1] in v86d? It looks very similar to
> what you have at present and there are plans to extend it to non
> x86(_64) archs.

It looks like an interesting solution and it is indeed similar to what
I'm currently using.  I'll consider switching to it in the next version
of v86d.

Thanks,
Michal

