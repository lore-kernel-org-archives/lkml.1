Return-Path: <linux-kernel-owner+w=401wt.eu-S935156AbZDHS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156AbZDHS45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbZDHS4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:56:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55907 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbZDHS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:56:40 -0400
Date: Wed, 8 Apr 2009 12:56:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: Prepare for hard drives w/ non-512 sector sizes
Message-ID: <20090408185639.GL20983@parisc-linux.org>
References: <20090408065955.GA29845@havoc.gtf.org> <20090408183243.GK20983@parisc-linux.org> <49DCF14F.1060407@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DCF14F.1060407@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:47:43PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >On Wed, Apr 08, 2009 at 02:59:55AM -0400, Jeff Garzik wrote:
> >>I checked this into libata-dev.git#sectsize and #NEXT...  comments
> >>welcome.  It's willy's patch, cut down such that it introduces no
> >>major behavior changes [READ CAPACITY improves slightly].
> >
> >Umm.  If you wanted me to split the patch up, why didn't you ask?
> 
> I've had trouble until recently simply getting you to post patches at 
> all.  It was faster and simpler for me to do it myself.

?!  Are you referring to the one incident where you asked me if I had
any patches for 2.6.30, I pointed at the TRIM patches and you quibbled
that I hadn't reposted the updates, only a git tree?

> >I really do think I should be credited as 'Author' here.  You credit me
> >in the patch description, but the automated tools don't show that.
> 
> If that is your preference, that's fine.  I did it this way to avoid 
> your taking the blame for anything I did, while still noting in the 
> patch description you did the original work.

Yes, that's my preference.  It's also the documented way to do things in
SubmittingPatches.

I'll be offline for the next week and unable to respond to email after
today.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
