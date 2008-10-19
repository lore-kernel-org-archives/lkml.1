Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbYJSRw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbYJSRw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYJSRwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:52:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYJSRwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:52:50 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Anholt <eric@anholt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <1224316142.4378.17.camel@vonnegut.anholt.net>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
	 <1224295858.4378.8.camel@vonnegut.anholt.net>
	 <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
	 <1224316142.4378.17.camel@vonnegut.anholt.net>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 19:52:28 +0200
Message-Id: <1224438749.10548.62.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 00:49 -0700, Eric Anholt wrote:

> Writing 3D drivers means running 3D games.  Running 3D games
> unfortunately means running a lot of 32-bit userland as the fun stuff is
> binary-only.  So I stick to a 32-bit system, becuase past experience
> trying to run both on the same system has been misery.

You can run 32bit user-space on a 64bit kernel just fine.
Any breakage, if anything, you find will need to get fixed anyway.

Also, one would hope Intel is poking these game writers to migrate to
64bit Linux ;-)

