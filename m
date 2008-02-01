Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYBAQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYBAQh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYBAQhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:37:18 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52450 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbYBAQhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:37:16 -0500
Date: Fri, 1 Feb 2008 17:37:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Avoid section mismatch involving arch_register_cpu
Message-ID: <20080201163718.GD13992@uranus.ravnborg.org>
References: <20080201145649.GA12318@mailshack.com> <20080201150312.GB13992@uranus.ravnborg.org> <1201879272.2433.1234541483@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201879272.2433.1234541483@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 04:21:12PM +0100, Alexander van Heukelum wrote:
> 
> On Fri, 1 Feb 2008 16:03:12 +0100, "Sam Ravnborg" <sam@ravnborg.org>
> said:
> > Hi Alexander.
> > 
> > See below for my take on the same warning.
> > It is already in x86.git pending merge.
> 
> Hi!
> 
> The patch you forwarded is in Linus' tree already. It only
> changed one warning into another one, however. My guess is
> that you did not see the new warning due to inlining, but I
> compiled with CONFIG_CC_OPTIMIZE_FOR_SIZE=y.

You are right - now I actually looked at your patch.

	Sam
