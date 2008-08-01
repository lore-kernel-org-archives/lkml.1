Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYHARVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYHARVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYHARVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:21:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbYHARVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:21:39 -0400
Date: Fri, 1 Aug 2008 10:21:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Karsten Keil <kkeil@suse.de>
cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH] mISDN cleanup user interface
In-Reply-To: <20080729195637.GB25929@pingi.kke.suse.de>
Message-ID: <alpine.LFD.1.10.0808011020000.3277@nehalem.linux-foundation.org>
References: <20080729195637.GB25929@pingi.kke.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Karsten Keil wrote:
>
> Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master

Grr. What's the status of this now? That branch is unpullable - you've put 
pretty much the same patch in twice, reverted it once, and added some 
merge into it too. So of the five commits, less than half are actually 
useful and worthwhile.

		Linus
