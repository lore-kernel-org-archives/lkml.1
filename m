Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZJ0AqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZJ0AqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZJ0AqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:46:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48804 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbZJ0AqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:46:04 -0400
Date: Tue, 27 Oct 2009 01:46:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       reinette chatre <reinette.chatre@intel.com>
Subject: Re: [Bug #14299] oops in wireless, iwl3945 related?
Message-ID: <20091027004600.GD5019@elf.ucw.cz>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
 <6dRYo8ss7vL.A.l8H.Xse5KB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dRYo8ss7vL.A.l8H.Xse5KB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-10-26 19:55:50, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14299
> Subject		: oops in wireless, iwl3945 related?
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2009-09-29 17:12 (28 days old)
> References	: http://marc.info/?l=linux-kernel&m=125424439725743&w=4

It did not happen again, and there were some fixes in that area. (It
happened 2 times total). Close it, I guess?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
