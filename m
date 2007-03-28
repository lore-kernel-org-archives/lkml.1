Return-Path: <linux-kernel-owner+w=401wt.eu-S964777AbXC1RCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777AbXC1RCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXC1RCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:02:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46819 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964777AbXC1RCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:02:23 -0400
Date: Wed, 28 Mar 2007 19:03:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clarify CONFIG_DEBUG_INFO help text
Message-ID: <20070328170306.GC14218@uranus.ravnborg.org>
References: <20070327212133.GA22409@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327212133.GA22409@schatzie.adilger.int>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 03:21:33PM -0600, Andreas Dilger wrote:
> The following patch adds some extra clarification to the CONFIG_DEBUG_INFO
> Kconfig help text.  The current text is mostly a recursive definition and
> doesn't really say much of anything.  When I first read this I thought it
> was going to enable extra verbosity in debug messages or something, but it
> is only enabling the "gcc -g" compile option in the Makefile.
> 
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Thanks, I have added this to kbuild.git

	Sam
