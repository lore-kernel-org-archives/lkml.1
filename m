Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYABT07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYABT07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYABT0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:26:49 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35879 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYABT0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:26:48 -0500
Date: Wed, 2 Jan 2008 20:26:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: (Try #2) [Patch 6/8] FRV: Drop 'TOPDIR' from Makefiles
Message-ID: <20080102192646.GE11217@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101073645.GG2496@hacking> <20080101102759.GF28913@uranus.ravnborg.org> <20080101140004.GF2499@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101140004.GF2499@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 10:00:04PM +0800, WANG Cong wrote:
> >
> >In this file we can just drop use of $(TOPDIR) since this is our
> >current directory anyway.
> 
> Thanks!
> 
> -------->
> 
> This patch drops TOPDIR from frv Makefiles.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 

Applied.

	Sam
