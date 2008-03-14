Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYCNHcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYCNHcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYCNHcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:32:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42830 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYCNHce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:32:34 -0400
Date: Fri, 14 Mar 2008 08:33:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Newall <davidn@davidnewall.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] PM: Remove legacy PM
Message-ID: <20080314073307.GB9465@elf.ucw.cz>
References: <200803132351.19794.rjw@sisk.pl> <47DA0DDB.7010403@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA0DDB.7010403@davidnewall.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-14 16:02:11, David Newall wrote:
> Rafael J. Wysocki wrote:
> > The first of the following two patches removes the legacy PM infrastructure
> > and the second one removes some of its remnants from the MIPS tree.
> 
> What does "legacy PM" mean?  Is it APM, which most assuredly needs to
> remain?

No, it is not APM. It issome obsolete code noone uses.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
