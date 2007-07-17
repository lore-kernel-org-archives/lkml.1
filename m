Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbXGQEBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbXGQEBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXGQEBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:01:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbXGQEBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:01:21 -0400
Date: Mon, 16 Jul 2007 21:00:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [git pull] more drm patches for 2.6.23-rc1
In-Reply-To: <Pine.LNX.4.64.0707170212310.2500@skynet.skynet.ie>
Message-ID: <alpine.LFD.0.999.0707162055380.19166@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707170212310.2500@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Dave Airlie wrote:
> 
> Please pull the 'drm-patches' branch from:
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> drm-patches

I really think this or the previous tree is buggy.

Trying to start any 3D client just hangs my Evo laptop hard. It's a Radeon 
Mobility 7500 behind a ICH4 southbridge, so standard Intel AGP, and not 
anything very usual gfx-chipwise either.

I don't have netconsole or anything, so I'm mixxing any potential oops, 
and I guess I should try that next, but not today. I'm hoping this is 
something obvious and/or already known, since my setup certainly isn't 
unusual.

			Linus
