Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYABTZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYABTZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYABTZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:25:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46475 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYABTZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:25:37 -0500
Date: Wed, 2 Jan 2008 20:25:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       dev-etrax@axis.com, Andreas Schwab <schwab@suse.de>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: (Try #3) [Patch 4/8] CRIS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080102192535.GC11217@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101072922.GE2496@hacking> <20080101102010.GD28913@uranus.ravnborg.org> <20080101133421.GD2499@hacking> <20080102062759.GF2493@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102062759.GF2493@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 02:27:59PM +0800, WANG Cong wrote:
> 
> Refine it as suggested by Andreas.
> 
> -------->
> 
> This patch removes TOPDIR from Cris Makefiles.
> 
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Andreas Schwab <schwab@suse.de>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Added Jesper to Cc and applied.

	Sam
