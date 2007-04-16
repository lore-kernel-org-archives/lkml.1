Return-Path: <linux-kernel-owner+w=401wt.eu-S1031013AbXDPXK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031013AbXDPXK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 19:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030991AbXDPXK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 19:10:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42649 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030894AbXDPXKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 19:10:55 -0400
Date: Mon, 16 Apr 2007 16:13:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       i4ldeveloper@listserv.isdn4linux.de, Karsten Keil <kkeil@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
Message-Id: <20070416161337.d59f2ea3.randy.dunlap@oracle.com>
In-Reply-To: <4623FB0E.4080602@imap.cc>
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
	<4623FB0E.4080602@imap.cc>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 00:39:10 +0200 Tilman Schmidt wrote:

> Am 15.04.2007 22:55 schrieb Robert P. J. Day:
> >   as i recall, the isdn4linux was *un*obsoleted, wasn't it?
> 
> Actually, it wasn't.
> 
> We *did* reach a consensus that isdn4linux is not obsolete in the
> accepted sense of the word, because there is no replacement for it
> so far.
> 
> OTOH I have since submitted (twice, in fact) a patch that would remove
> the "(obsolete)" label from the Kconfig entry, but somehow nothing
> ever became of it. My submissions just linger in LKML, uncommented and
> unmerged.

Did you submit the patch to Andrew Morton?
Is the patch in the -mm patchset?
Did Karsten ack the patch?

If the patch is in -mm and it's not critical (like this subject),
then it probably won't be merged until after 2.6.21 is released...


> To sum it up, we agree that the "(obsolete)" label is wrong, but we
> won't remove it. I have no idea how to resolve that situation.
> 
> What I do know is that it would be very wrong to remove isdn4linux,
> because it has an existing userbase with nowhere else to go.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
