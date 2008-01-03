Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYACT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYACT72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYACT7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:59:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47356 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYACT7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:59:20 -0500
Date: Thu, 3 Jan 2008 20:59:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Mikael Starvik <mikael.starvik@axis.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, dev-etrax@axis.com,
       Andreas Schwab <schwab@suse.de>
Subject: Re: (Try #3) [Patch 4/8] CRIS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080103195920.GD21227@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101072922.GE2496@hacking> <20080101102010.GD28913@uranus.ravnborg.org> <20080101133421.GD2499@hacking> <20080102062759.GF2493@hacking> <20080102192535.GC11217@uranus.ravnborg.org> <20080103170322.GC9512@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103170322.GC9512@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 06:03:22PM +0100, Jesper Nilsson wrote:
> On Wed, Jan 02, 2008 at 08:25:35PM +0100, Sam Ravnborg wrote:
> > On Wed, Jan 02, 2008 at 02:27:59PM +0800, WANG Cong wrote:
> > > 
> > > Refine it as suggested by Andreas.
> > > 
> > > -------->
> > > 
> > > This patch removes TOPDIR from Cris Makefiles.
> 
> We had the TOPDIR replaced with $(srcdir) already, but this looks better.
> 
> Compiles OK for both EtraxFS and ARTPEC-3 cpus in our tree.

Thanks - added a:
Tested-by: Jesper Nilsson <jesper.nilsson@axis.com>

	Sam
