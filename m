Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYABT1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYABT1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYABT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:27:15 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46856 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYABT1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:27:14 -0500
Date: Wed, 2 Jan 2008 20:27:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Tim Shimmin <xfs-masters@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
Subject: Re: (Try #2) [Patch 7/8] FS: Drop 'TOPDIR' from Makefiles and remove some dead code
Message-ID: <20080102192709.GF11217@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101074105.GH2496@hacking> <20080101103026.GG28913@uranus.ravnborg.org> <20080101142852.GG2499@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101142852.GG2499@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 10:28:52PM +0800, WANG Cong wrote:
> 
> >
> >The whole "Maintainer rules" part of this file should be deleted.
> >I cannot see how it can be used anyway.
> 
> Agreed.
> 
> I delete them all and renew the patch.
> Passed compiling test.
> 
> --------->
> 
> This patch drops TOPDIR since it's obsolete and removes
> some dead code from fs/smbfs/Makefile.
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Tim Shimmin <xfs-masters@oss.sgi.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied.

	Sam
