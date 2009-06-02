Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZFBJNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZFBJNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZFBJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:12:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47107 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZFBJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:12:58 -0400
Date: Tue, 2 Jun 2009 11:12:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Script to integrate MAINTAINERS P: and M: lines
Message-ID: <20090602091252.GA15756@elf.ucw.cz>
References: <cover.1243131992.git.joe@perches.com> <136e58c251157179f19a7eecedd1e6fe71a3e6d9.1243131992.git.joe@perches.com> <20090526144141.570594cf.akpm@linux-foundation.org> <1243455722.27337.65.camel@Joe-Laptop.home> <20090527151510.fb773db6.akpm@linux-foundation.org> <1243878331.3402.52.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243878331.3402.52.camel@Joe-Laptop.home>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-01 10:45:31, Joe Perches wrote:
> Here's a script to convert the MAINTAINERS file
> to a single-line format.
> 
> from:
> 	P:	name
> 	M:	address
> to
> 	M:	name <address>
> 
> Please run the script and apply the result when convenient.

I don't know if it is appropriate for meta-patch, but:

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
