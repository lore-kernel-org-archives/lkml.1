Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZKTPTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZKTPTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZKTPTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:19:03 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:25939 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZKTPTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:19:02 -0500
Date: Fri, 20 Nov 2009 10:18:22 -0500
From: Chris Mason <chris.mason@oracle.com>
To: tytso@mit.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Monakhov <rjevskiy@gmail.com>, Sage Weil <sage@newdream.net>
Subject: Re: [Bug #14619] ext3/jbd oops in journal_start
Message-ID: <20091120151822.GV3110@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>, tytso@mit.edu,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Dmitry Monakhov <rjevskiy@gmail.com>, Sage Weil <sage@newdream.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
 <xXQGFmujPl.A.wQG.8SdALB@chimera>
 <20091120150648.GB4921@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120150648.GB4921@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B06B342.016D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:06:48AM -0500, tytso@mit.edu wrote:
> On Mon, Nov 16, 2009 at 11:37:46PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14619
> > Subject		: ext3/jbd oops in journal_start
> > Submitter	: Sage Weil <sage@newdream.net>
> > Date		: 2009-10-31 6:14 (17 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125696970418300&w=4
> > 
> 
> Sage, any updates on this?  What was the last kernel version where you
> weren't having this problem?  Sounds like you can't mount any ext3
> file systems at all?

This is a btrfs bug and is fixed.  I've updated the bugzilla.

-chris

