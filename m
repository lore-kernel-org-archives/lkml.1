Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZAAAFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZAAAFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbZAAAFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:05:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756533AbZAAAFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:05:37 -0500
Date: Wed, 31 Dec 2008 16:05:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches, part 1
In-Reply-To: <20081231231026.GB28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0812311557580.5086@localhost.localdomain>
References: <20081231074356.GA28946@ZenIV.linux.org.uk> <alpine.LFD.2.00.0812310905580.5086@localhost.localdomain> <20081231231026.GB28946@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Al Viro wrote:

> On Wed, Dec 31, 2008 at 09:21:57AM -0800, Linus Torvalds wrote:
> > 
> > Al, can you please try to clean up the commit messages? 
> 
> Done.  Same branch, same patches...

Thanks. Pulled. You had missed one (e2b689d82), but now it's par for the 
course (ie just the normal occasional mistake) and so I don't mind any 
more.

		Linus
