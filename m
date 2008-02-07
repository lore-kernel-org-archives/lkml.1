Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYBGRj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYBGRj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760960AbYBGRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:39:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759090AbYBGRjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:39:03 -0500
Date: Thu, 7 Feb 2008 09:38:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm patches for 2.6.25
In-Reply-To: <alpine.DEB.0.82.0802070534290.26136@skynet.skynet.ie>
Message-ID: <alpine.LFD.1.00.0802070937400.2883@woody.linux-foundation.org>
References: <alpine.DEB.0.82.0802070534290.26136@skynet.skynet.ie>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Feb 2008, Dave Airlie wrote:
> 
> Please pull the 'drm-patches' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

Very happy to. I can confirm that this does indeed finally make 
suspend/resume work on my laptop, screen and all.

			Linus
