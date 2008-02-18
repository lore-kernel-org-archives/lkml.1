Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYBRC6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYBRC6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYBRC6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:58:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbYBRC6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:58:07 -0500
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Feb 2008 13:58:10 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18360.62530.142639.141506@notabene.brown>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags, one more time
In-Reply-To: message from Linus Torvalds on Friday February 8
References: <9525.1202489479@vena.lwn.net>
	<alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday February 8, torvalds@linux-foundation.org wrote:
> 
> 
> On Fri, 8 Feb 2008, Jonathan Corbet wrote:
> > +
> > +These tags are:
> > +
> > +From: 	   	The original author of the patch.  This tag will ensure
> > +		that credit is properly given when somebody other than the
> > +		original author submits the patch.
> 
> "From:" is not a tag. It's a special marker at the *top* (and _only_ the 
> top) of the email, which indicates authorship. It goes along with markers 
> like "Date:" and "Subject:", and has nothing to do with the sign-off-like 
> tags at the end.

You may be right, but when I email patches to akpm that I did not
author, and that don't have a From: tag in the body saying who did
author them, then akpm tells me off.  And I don't like that :-(

Maybe we need "tags in git commit logs" and "tags in email sent to
akpm" and ... :-)

NeilBrown
