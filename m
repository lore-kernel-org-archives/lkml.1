Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZKTPcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZKTPcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZKTPcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:32:33 -0500
Received: from THUNK.ORG ([69.25.196.29]:40560 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKTPcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:32:32 -0500
Date: Fri, 20 Nov 2009 10:32:29 -0500
From: tytso@mit.edu
To: Chris Mason <chris.mason@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Sage Weil <sage@newdream.net>
Subject: Re: [Bug #14619] ext3/jbd oops in journal_start
Message-ID: <20091120153229.GC4921@thunk.org>
Mail-Followup-To: tytso@mit.edu, Chris Mason <chris.mason@oracle.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Dmitry Monakhov <rjevskiy@gmail.com>, Sage Weil <sage@newdream.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
 <xXQGFmujPl.A.wQG.8SdALB@chimera>
 <20091120150648.GB4921@thunk.org>
 <20091120151822.GV3110@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120151822.GV3110@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:18:22AM -0500, Chris Mason wrote:
> > Sage, any updates on this?  What was the last kernel version where you
> > weren't having this problem?  Sounds like you can't mount any ext3
> > file systems at all?
> 
> This is a btrfs bug and is fixed.  I've updated the bugzilla.

Thanks!  I remember seeing that but I didn't connect it to this
bugzilla entry.

Just trying to do my part to clear out open regressions after Linus
sent out his pre-thanksgiving grump.  :-)

						- Ted
