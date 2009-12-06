Return-Path: <linux-kernel-owner+w=401wt.eu-S934065AbZLFSrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbZLFSrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933945AbZLFSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:47:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933941AbZLFSrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:47:09 -0500
Date: Sun, 6 Dec 2009 10:46:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] bkl core patches for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912061044530.3560@localhost.localdomain>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Dec 2009, Thomas Gleixner wrote:
> 
> Please pull the latest bkl-core-for-linus git tree from:

Hmm. Seeing this, I wonder: has anybody kept track of the reiserfs bkl 
removal?

		Linus
