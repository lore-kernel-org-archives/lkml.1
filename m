Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYABR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYABR1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYABR1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:27:04 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41642 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYABR1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:27:01 -0500
Date: Wed, 2 Jan 2008 18:27:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: (Try #2) [Patch 1/8] UML: Remove 'TOPDIR' from Makefiles
Message-ID: <20080102172701.GB9772@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101071846.GB2496@hacking> <20080101103342.GH28913@uranus.ravnborg.org> <20080101104942.GI28913@uranus.ravnborg.org> <20080101130125.GA2499@hacking> <20080102150255.GA5567@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102150255.GA5567@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 10:02:55AM -0500, Jeff Dike wrote:
> On Tue, Jan 01, 2008 at 09:01:25PM +0800, WANG Cong wrote:
> > TOPDIR is obsolete, use srctree instead.
> > This patch removes TOPDIR from all UML Makefiles.
> 
> Thanks, I'll send this to Andrew.

Thanks Jeff.

	Sam
