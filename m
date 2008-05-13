Return-Path: <linux-kernel-owner+w=401wt.eu-S1761093AbYEMPsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093AbYEMPsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbYEMPsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:48:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756950AbYEMPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:48:38 -0400
Date: Tue, 13 May 2008 08:48:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
cc: Jens Rottmann <JRottmann@LiPPERT-AT.de>, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, linux-geode@bombadil.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: lxfb driver regression
In-Reply-To: <20080512185148.104fc4c3@ephemeral>
Message-ID: <alpine.LFD.1.10.0805130847150.3019@woody.linux-foundation.org>
References: <20080507210836.1eb61b8f@ephemeral> <48230694.5010505@LiPPERT-AT.de> <20080512185148.104fc4c3@ephemeral>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 May 2008, Andres Salomon wrote:
> 
> Sorry for the delay, I got around to testing this today.  It works
> much better on an XO, so I've ack'd it.

If people expect me to apply that patch, I hope they'll re-send (with acks 
etc). Otherwise I just expect I'll get it through the normal fbdev queues 
(which is often Andrew, but shouldn't be).

		Linus
