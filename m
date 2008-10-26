Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbYJZLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbYJZLu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYJZLuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:50:13 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:46771 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYJZLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:50:12 -0400
Date: Sun, 26 Oct 2008 13:50:10 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       walt <w41ter@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11846] commit a802dd0e breaks console keyboard input
Message-ID: <20081026125010.GB4787@osiris.boeblingen.de.ibm.com>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.QGC.iV5AJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t1C3RWL0r7M.A.QGC.iV5AJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 10:06:47PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11846
> Subject		: commit a802dd0e breaks console keyboard input
> Submitter	: walt <w41ter@gmail.com>
> Date		: 2008-10-24 0:09 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=122480701528944&w=4
> Handled-By	: Heiko Carstens <heiko.carstens@de.ibm.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122487763507703&w=4

Linus fixed this with 4403b406d4369a275d483ece6ddee0088cc0d592
'Revert "Call init_workqueues before pre smp initcalls."'

Thanks,
Heiko
