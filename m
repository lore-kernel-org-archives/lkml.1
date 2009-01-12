Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZALSNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZALSNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZALSNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:13:20 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60131 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbZALSNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:13:19 -0500
Subject: Re: [GIT PATCH] more SCSI updates for 2.6.28
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4969D00C.2010209@panasas.com>
References: <1231459859.3237.116.camel@localhost.localdomain>
	 <4969D00C.2010209@panasas.com>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 12:13:15 -0600
Message-Id: <1231783995.3256.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 12:55 +0200, Boaz Harrosh wrote:
> James Bottomley wrote:
> > This is the second round of SCSI updates for the current merge window.
> > It also includes a round of bug fixes for the previous updates ...
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > 
> > The short changelog is:
> > 
> 
> So what is the verdict for OSD initiator. Is it not going into 2.6.29?

Well, Linus obviously has a different idea of the meaning of "extended
merge window" than I do.  I've got to sort out a few other things that
didn't quite make it as well.

James


