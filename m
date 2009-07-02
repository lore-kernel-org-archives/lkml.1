Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZGBVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZGBVie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZGBVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:38:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46676 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZGBVi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:38:27 -0400
Date: Thu, 2 Jul 2009 23:38:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Arnold <jbarnold@ksplice.com>
Cc: linux-kernel@vger.kernel.org, tabbott@ksplice.com, wdaher@ksplice.com,
       andersk@ksplice.com, nelhage@ksplice.com, price@ksplice.com,
       geofft@ksplice.com
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
Message-ID: <20090702213823.GB1485@ucw.cz>
References: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu> <20090630063152.GC1351@ucw.cz> <alpine.DEB.1.10.0907010909250.26501@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907010909250.26501@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-02 15:06:09, Jeff Arnold wrote:
> On Tue, 30 Jun 2009, Pavel Machek wrote:
> 
> > Hmmm, so what are its limits? How much manual work is involved?
> 
> The Ksplice technical paper (http://www.ksplice.com/paper) describes in 
> detail how Ksplice works--including what it can do automatically and what 
> requires assistance from a programmer or other tools.

Ok, I see now.. if data structures change, manual intervention
required. Only suitable for simple patches.

> > Lets say I want 2.6.30 -> 2.6.31-rc1... that's just source patch, right?
> 
> For now, we're using Ksplice to apply bug-fix patches, such as from the 
> stable tree (2.6.29 -> 2.6.29.5, not 2.6.30 -> 2.6.31).

Yep, and you'll probably not be able to do major changes, ever.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
