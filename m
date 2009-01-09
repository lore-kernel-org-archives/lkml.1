Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZAIV6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZAIV6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZAIV5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:57:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbZAIV5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:57:47 -0500
Date: Fri, 9 Jan 2009 13:56:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
In-Reply-To: <20090109120254.496f75d2@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0901091356160.6528@localhost.localdomain>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <20090109120254.496f75d2@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Alan Cox wrote:

> > Of course, this assumes that someone will actually perform that testing
> > and review.  Chances are that it'll just sit there, getting nothing more
> > than compilation testing.
> 
> Almost every distribution ships the updated version and has done for ages
> - exactly what kind of testing is going to beat that ?

Yes, if this is really in use by everybody, then not merging it is kind of 
pointless. 

		Linus
