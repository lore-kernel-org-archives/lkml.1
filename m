Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXBYKox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXBYKox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXBYKow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:44:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40411 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797AbXBYKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:44:31 -0500
Date: Sun, 25 Feb 2007 11:44:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 5/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Message-ID: <20070225104427.GJ2045@elf.ucw.cz>
References: <200702231116.23607.rjw@sisk.pl> <200702231123.44687.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231123.44687.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-02-23 11:23:43, Rafael J. Wysocki wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Remove PF_NOFREEZE from the rcutorture thread, adding a try_to_freeze() call as
> required.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
