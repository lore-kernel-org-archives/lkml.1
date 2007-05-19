Return-Path: <linux-kernel-owner+w=401wt.eu-S1765066AbXESWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765066AbXESWIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764680AbXESWHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:07:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:21902 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761416AbXESWHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=AGsGYR8LDs2yhRrm47EqA9ujYQtwlcwB1P0fjUFlKfK/ResjlAbZ9la7THxMmWWeqrG586unDx4GH5/I3r0QDKFC12uy8f/rxJ3yFEyX/38K38XhtX3ZmddWmqhNtPJfzyEsYDzcoIsCVlOn1gooyymag+L3rQw5utFfB7HAKZY=
Message-ID: <464F74FC.8000800@googlemail.com>
Date: Sun, 20 May 2007 00:06:52 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Avuton Olrich <avuton@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2/2] 2.6.22-rc2: known regressions with patches
References: <464F7400.2070701@googlemail.com>
In-Reply-To: <464F7400.2070701@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



File systems

Subject    : 2.6.21-git10/11: files getting truncated on xfs
References : http://lkml.org/lkml/2007/5/9/410
Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
Handled-By : David Chinner <dgc@sgi.com>
Patch      : http://lkml.org/lkml/2007/5/12/93
Status     : patch available



Memory management

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



Suspend

Subject    : resume after suspend-to-disk broken when USB compiled in
References : http://bugzilla.kernel.org/show_bug.cgi?id=8498
Submitter  : Avuton Olrich <avuton@gmail.com>
Patch      : http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/usb-make-the-autosuspend-workqueue-thread-freezable.patch
Status     : patch available



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
