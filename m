Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYFUTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYFUTfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbYFUTf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:35:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbYFUTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:35:28 -0400
Date: Sat, 21 Jun 2008 12:34:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates vs. v2.6.26-rc6
In-Reply-To: <20080621185516.GA29869@mars.solarsys.private>
Message-ID: <alpine.LFD.1.10.0806211232260.3167@woody.linux-foundation.org>
References: <20080619123304.GF7306@mars.solarsys.private> <alpine.LFD.1.10.0806201231590.3167@woody.linux-foundation.org> <20080620203023.GJ7306@mars.solarsys.private> <20080621185516.GA29869@mars.solarsys.private>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Jun 2008, Mark M. Hoffman wrote:
> 
> Still down... so I've attached a git bundle (to preserve history).

Thanks, that works for me. I don't much like bundles for normal work, but 
for cases like this it's convenient. I faked out the commit message to 
look like it was done the traditional way and lm-sensors was still up..

		Linus
