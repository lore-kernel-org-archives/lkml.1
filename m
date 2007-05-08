Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbXEHSxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbXEHSxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbXEHSxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:53:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbXEHSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:53:38 -0400
Date: Tue, 8 May 2007 11:53:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [git pull] drm tree with driver changes for 2.6.22-rc1
In-Reply-To: <Pine.LNX.4.64.0705080714560.5546@skynet.skynet.ie>
Message-ID: <alpine.LFD.0.98.0705081152300.3974@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0705080714560.5546@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Dave Airlie wrote:
> 
> Please pull the 'drm-patches' branch from
> git://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

That's not a valid URL. "master.kernel.org" doesn't run the git-daemon. 
Please fix your script.

		Linus
