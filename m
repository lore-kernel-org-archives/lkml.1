Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbXEMTNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbXEMTNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXEMTNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:13:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757314AbXEMTM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:12:58 -0400
Date: Sun, 13 May 2007 12:11:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>,
       Antonino Ingargiola <tritemio@gmail.com>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Chinner <dgc@sgi.com>, Charles Gagalac <charle97@yahoo.com>
Subject: Re: [1/2] 2.6.22-rc1: known regressions
Message-Id: <20070513121134.16eea69e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705131118160.3212@alien.or.mcafeemobile.com>
References: <46475595.4050105@googlemail.com>
	<Pine.LNX.4.64.0705131118160.3212@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 11:19:33 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Sun, 13 May 2007, Michal Piotrowski wrote:
> 
> > Subject    : applications under wine freezes
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8462
> > Submitter  : Charles Gagalac <charle97@yahoo.com>
> > Caused-By  : Davide Libenzi <davidel@xmailserver.org>
> >              commit 6192bd536f96c6a0d969081bc71ae24f9319bfdc
> > Handled-By : Davide Libenzi <davidel@xmailserver.org>
> > Status     : problem is being debugged
> 
> This has been fixed. Confirmed by myself and Charles Gagalac. Patches have 
> been sent to Andrew.

On Friday.  Should've got them into -rc1.  I suck.  Sorry.
