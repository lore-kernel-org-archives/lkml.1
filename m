Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZKTPGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZKTPGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZKTPGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:06:47 -0500
Received: from THUNK.ORG ([69.25.196.29]:36342 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZKTPGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:06:46 -0500
Date: Fri, 20 Nov 2009 10:06:48 -0500
From: tytso@mit.edu
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Sage Weil <sage@newdream.net>
Subject: Re: [Bug #14619] ext3/jbd oops in journal_start
Message-ID: <20091120150648.GB4921@thunk.org>
Mail-Followup-To: tytso@mit.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Dmitry Monakhov <rjevskiy@gmail.com>, Sage Weil <sage@newdream.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
 <xXQGFmujPl.A.wQG.8SdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xXQGFmujPl.A.wQG.8SdALB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 11:37:46PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14619
> Subject		: ext3/jbd oops in journal_start
> Submitter	: Sage Weil <sage@newdream.net>
> Date		: 2009-10-31 6:14 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=125696970418300&w=4
> 

Sage, any updates on this?  What was the last kernel version where you
weren't having this problem?  Sounds like you can't mount any ext3
file systems at all?

					- Ted
