Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYGSCHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYGSCHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 22:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYGSCH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 22:07:28 -0400
Received: from w241.dkm.cz ([62.24.88.241]:36611 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYGSCH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 22:07:28 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 22:07:27 EDT
Date: Sat, 19 Jul 2008 03:59:24 +0200
From: Petr Baudis <pasky@suse.cz>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: gitdm v0.10 available
Message-ID: <20080719015924.GC32184@machine.or.cz>
References: <20080718154657.7ff0cf9e@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718154657.7ff0cf9e@bike.lwn.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Fri, Jul 18, 2008 at 03:46:57PM -0600, Jonathan Corbet wrote:
> Gitdm (the "git data miner") is the tool that Greg KH and I have used
> to crank out statistics on where kernel patches come from.  For the
> curious, I have (finally) put up a public repository for gitdm at:
> 
> 	git://git.lwn.net/gitdm.git
> 
> That repository is currently tagged at v0.10, for whatever that's worth.

  or you can examine it over gitweb now set up at

	http://repo.or.cz/w/git-dm.git

				Petr "Pasky" Baudis
