Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZIXRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZIXRip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZIXRin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:38:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbZIXRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:38:42 -0400
Date: Thu, 24 Sep 2009 10:38:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Anholt <eric@anholt.net>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm-intel updates for 2.6.32.
In-Reply-To: <1253810459.7409.20.camel@gaiman.anholt.net>
Message-ID: <alpine.LFD.2.01.0909241036390.3303@localhost.localdomain>
References: <1253810459.7409.20.camel@gaiman.anholt.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Sep 2009, Eric Anholt wrote:

> The following changes since commit cecc6b63a5de547a345c491bb4c18c01a15984a4:
>   Alex Deucher (1):
>         drm/radeon/r600: use fence->timeout directly
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-next

Ok. I fixed up a conflict due to the new VGA arbitration thing, which 
code-wise looked trivial. But you should probably check that there isn't 
any subtle interactions going on.

		Linus
