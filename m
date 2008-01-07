Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYAGUe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYAGUe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYAGUeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:34:20 -0500
Received: from dvhart.com ([64.146.134.43]:39674 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYAGUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:34:19 -0500
Message-ID: <47828CC7.7060106@mbligh.org>
Date: Mon, 07 Jan 2008 12:34:15 -0800
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Cc: bugme-admin@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>
Subject: change SCSI owner in bugzilla
References: <20080106161635.GL2082@does.not.exist>
In-Reply-To: <20080106161635.GL2082@does.not.exist>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Date: Sun, 06 Jan 2008 10:00:33 -0600
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> To: Adrian Bunk <bunk@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
> 	Linus Torvalds <torvalds@linux-foundation.org>,
> 	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
> 	Andrew Morton <akpm@linux-foundation.org>,
> 	Al Viro <viro@ftp.linux.org.uk>
> Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
> 
> On Sun, 2008-01-06 at 17:45 +0200, Adrian Bunk wrote:
>> Bugzilla for tracking and mailing lists for discussing are not mutually 
>> exclusive.
> 
> I didn't ever say they were.  What I said was we needed the work flow on
> the mailing lists.
> 
>> What about asking the Bugzilla admins to set the default owner of new 
>> SCSI bugs to linux-scsi@vger.kernel.org?
>>
>> This way all SCSI bugs submitted in Bugzilla will automatically be 
>> forwarded to the linux-scsi mailing list.
> 
> Well, I've only been asking for this for the last two years.  If you can
> actually make it happen, I'd be eternally grateful.

OK, changed it.

I don't think this is the right way to do it, as you'll get email for
every change to every bug until it's assigned, but seeing as that's what
you asked for, and we can't seem to get vger to take bounces, I guess
it'll do.

Let me know if (a) it works OK, and (b) you want the driver ones changed
over as well.

M.
