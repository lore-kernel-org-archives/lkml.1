Return-Path: <linux-kernel-owner+w=401wt.eu-S932277AbYENO4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbYENO4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763225AbYENO4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:56:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51613 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763212AbYENO4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:56:13 -0400
Date: Wed, 14 May 2008 16:55:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/24] vfs: fixes and cleanups + add helpers to check r/o bind mounts
Message-ID: <20080514145552.GA6615@ucw.cz>
References: <20080506091327.259950960@szeredi.hu> <20080506091632.GA28032@infradead.org> <E1JtKTz-0001BC-BO@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JtKTz-0001BC-BO@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Here it is again as a single series (without the ecryptfs one already
> > > merged).
> > > 
> > > I've addressed Christoph's comments.
> > 
> > And totally ignored Al's while merging the second rejected series into
> > the first one.
> 
> Al doesn't like it but everybody else does.  His excuses are very
> hollow and hypocritical, just take this for example: "Except that it

Ok, but perhaps you should have mentioned that in the changelog at the
beggining of series?

'I addressed Christoph's comments, but I believe Al is wrong'...?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
