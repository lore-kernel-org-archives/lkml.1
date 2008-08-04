Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYHDOpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYHDOpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYHDOo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:44:59 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52528 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbYHDOo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:44:59 -0400
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.27-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080804142927.GG8301@fluff.org.uk>
References: <1217800985.4179.55.camel@localhost.localdomain>
	 <20080804142927.GG8301@fluff.org.uk>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 09:44:52 -0500
Message-Id: <1217861092.3318.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 15:29 +0100, Ben Dooks wrote:
> On Sun, Aug 03, 2008 at 05:03:05PM -0500, James Bottomley wrote:
> > This is just a small selection of four fixes, one expanding driver
> > bindings and the other three fixing actual bugs (all of which need
> > backporting to 2.6.26 I'm afraid).
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The short changelog is:
> > 
> > HighPoint Linux Team (1):
> 
> I thought group (or non-person) submissions where explicitly
> prohibitted in the signoff section in Documentation/SubmittingPatches

Not as I read it.  It says:

        then you just add a line saying
        
                Signed-off-by: Random J Developer
        <random@developer.example.org>
        
        using your real name (sorry, no pseudonyms or anonymous
        contributions.)
        
Which doesn't preclude company signoffs (as long as it's a real
company).  Of course, most companies worry about the legal liability
from the GPL and the DCO, which is why we get so few of them.

James


