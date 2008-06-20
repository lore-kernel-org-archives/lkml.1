Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYFTTgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYFTTgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYFTTg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:36:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbYFTTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:36:28 -0400
Date: Fri, 20 Jun 2008 12:32:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates vs. v2.6.26-rc6
In-Reply-To: <20080619123304.GF7306@mars.solarsys.private>
Message-ID: <alpine.LFD.1.10.0806201231590.3167@woody.linux-foundation.org>
References: <20080619123304.GF7306@mars.solarsys.private>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jun 2008, Mark M. Hoffman wrote:
> 
> Please pull from:
> 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

I'm just getting:

	fatal: Unable to look up lm-sensors.org (port 9418) (Temporary failure in name resolution)

do you have DNS problems?

		Linus
