Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbYAGUuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbYAGUuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbYAGUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:50:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:27238 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbYAGUuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=P1DaJTwY0Gc/T2Ak3zMQkK4X2nFevCGfcQmn/vw4Yb4QrexX+vU0Ubakhetm9Bm1nQW1JYmb883951woEbINoZRHLyz2wI9Jw5rN2QdqpsSNGZhCA1cx8fa1DraiqJlDFmmt5xue1XJPkmASn9Vfgl/m8Q5t1hOOXKxpk2RVYnE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Martin Bligh <mbligh@mbligh.org>
Subject: Re: change SCSI owner in bugzilla
Date: Mon, 7 Jan 2008 22:01:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>
References: <20080106161635.GL2082@does.not.exist> <47828CC7.7060106@mbligh.org>
In-Reply-To: <47828CC7.7060106@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801072201.20115.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008, Martin Bligh wrote:
> 
> > Date: Sun, 06 Jan 2008 10:00:33 -0600
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > To: Adrian Bunk <bunk@kernel.org>
> > Cc: Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
> > 	Linus Torvalds <torvalds@linux-foundation.org>,
> > 	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
> > 	Andrew Morton <akpm@linux-foundation.org>,
> > 	Al Viro <viro@ftp.linux.org.uk>
> > Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
> > 
> > On Sun, 2008-01-06 at 17:45 +0200, Adrian Bunk wrote:
> >> Bugzilla for tracking and mailing lists for discussing are not mutually 
> >> exclusive.
> > 
> > I didn't ever say they were.  What I said was we needed the work flow on
> > the mailing lists.
> > 
> >> What about asking the Bugzilla admins to set the default owner of new 
> >> SCSI bugs to linux-scsi@vger.kernel.org?
> >>
> >> This way all SCSI bugs submitted in Bugzilla will automatically be 
> >> forwarded to the linux-scsi mailing list.
> > 
> > Well, I've only been asking for this for the last two years.  If you can
> > actually make it happen, I'd be eternally grateful.
> 
> OK, changed it.

Could you also change IDE to linux-ide mailing list while at it?

Thanks,
Bart
