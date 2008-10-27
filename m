Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbYJ0Rvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbYJ0Rvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYJ0Rvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:51:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYJ0Rve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:51:34 -0400
Subject: Re: [Bug #11838] general protection fault:
 =?ISO-8859-1?Q?=A0from?= release_blocks_on_commit
From: Eric Paris <eparis@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, sandeen@redhat.com
In-Reply-To: <t1C3RWL0r7M.A.wXC.qV5AJB@chimera>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera>
	 <t1C3RWL0r7M.A.wXC.qV5AJB@chimera>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 13:51:07 -0400
Message-Id: <1225129867.3274.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 22:06 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11838
> Subject		: general protection fault:  from release_blocks_on_commit
> Submitter	: Eric Paris <eparis@redhat.com>
> Date		: 2008-10-21 14:03 (5 days old)
> References	: http://lkml.org/lkml/2008/10/21/248

Pulled from Linus's git today so it is a 2.6.28-rc2+ kernel and this is
still a regression I was able to hit.

-Eric

