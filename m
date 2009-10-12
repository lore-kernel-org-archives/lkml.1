Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbZJLVwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbZJLVwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbZJLVwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:52:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbZJLVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:51:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [Bug #14370] ext4 corruptions
Date: Mon, 12 Oct 2009 23:53:04 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera> <r-4Wjt4coy.A.FWD.eal0KB@chimera> <1255330257.2180.1.camel@mini>
In-Reply-To: <1255330257.2180.1.camel@mini>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122353.04712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Alexey Fisher wrote:
> Am Montag, den 12.10.2009, 00:22 +0200 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14370
> > Subject		: ext4 corruptions
> > Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> > Date		: 2009-10-09 19:20 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125511643504864&w=4
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> This can be removed, it is duplicate of this bug:
> http://bugzilla.kernel.org/show_bug.cgi?id=14354

Thanks, I closed #14370 as a duplicate of #14354.

Best,
Rafael
