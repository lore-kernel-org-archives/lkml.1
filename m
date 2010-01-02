Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740Ab0ABTUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab0ABTUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483Ab0ABTUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:20:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab0ABTUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:20:10 -0500
Date: Sat, 2 Jan 2010 11:19:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [GIT PULL] reiserfs fixes
In-Reply-To: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.00.1001021118420.3630@localhost.localdomain>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jan 2010, Frederic Weisbecker wrote:
> 
> These changes fix a lot of lock inversions, some of them were
> triggering soft lockups very easily in xattrs operations.

Should 2.6.32-stable merge this branch too?

		Linus
