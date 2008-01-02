Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYABPE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYABPE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYABPEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:04:48 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54173 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYABPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:04:48 -0500
Date: Wed, 2 Jan 2008 10:02:55 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: (Try #2) [Patch 1/8] UML: Remove 'TOPDIR' from Makefiles
Message-ID: <20080102150255.GA5567@c2.user-mode-linux.org>
References: <20080101071311.GA2496@hacking> <20080101071846.GB2496@hacking> <20080101103342.GH28913@uranus.ravnborg.org> <20080101104942.GI28913@uranus.ravnborg.org> <20080101130125.GA2499@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101130125.GA2499@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 09:01:25PM +0800, WANG Cong wrote:
> TOPDIR is obsolete, use srctree instead.
> This patch removes TOPDIR from all UML Makefiles.

Thanks, I'll send this to Andrew.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
