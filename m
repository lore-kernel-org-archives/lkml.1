Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681Ab0ABTWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0ABTWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823Ab0ABTWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:22:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab0ABTWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:22:35 -0500
Date: Sat, 2 Jan 2010 11:21:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [GIT PULL] reiserfs fixes
In-Reply-To: <alpine.LFD.2.00.1001021118420.3630@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001021119570.3630@localhost.localdomain>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <alpine.LFD.2.00.1001021118420.3630@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jan 2010, Linus Torvalds wrote:
> 
> Should 2.6.32-stable merge this branch too?

Never mind, none of the reiserfs bkl-removal went into 2.6.32. We had some 
other BKL work that got in there, but all the reiserfs stuff is 
post-2.6.32 only, I guess.

		Linus
