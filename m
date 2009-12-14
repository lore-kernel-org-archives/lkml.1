Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZLNLSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZLNLSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZLNLSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:18:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55118 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbZLNLSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:18:52 -0500
Date: Mon, 14 Dec 2009 12:18:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Emese Revfy <re.emese@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
 2.6.32-git-053fe57ac v2
Message-ID: <20091214111841.GA1959@elf.ucw.cz>
References: <cover.1260662994.git.re.emese@gmail.com>
 <20091214003836.GD7812@parisc-linux.org>
 <4B2595E7.701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2595E7.701@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-14 02:33:27, Emese Revfy wrote:
> Matthew Wilcox wrote:
> > On Mon, Dec 14, 2009 at 12:59:08AM +0100, re.emese@gmail.com wrote:
> >> From: Emese Revfy <re.emese@gmail.com>
> >>
> >> Hello everyone!
> >>
> >> The following patch series attempts to constify several structures
> >> that hold function pointers. This is only the initial batch, there
> >> are about over 150 candidate structures, some of which can be
> >> constified as well, I plan to submit them in the future.
> > 
> > What a complete waste of time.  Until you respond to Al's:
> 
> I did: http://lkml.org/lkml/2009/12/5/140

Yes, you said we should ignore the patches.

> For even more discussion see: http://lkml.org/lkml/2009/12/6/111

I don't think you explained why we want the patches.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
