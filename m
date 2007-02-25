Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXBYKo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXBYKo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBYKo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:44:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40441 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793AbXBYKoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:44:54 -0500
Date: Sun, 25 Feb 2007 11:44:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: Re: [RFC][PATCH 6/7] Freezer: Remove PF_NOFREEZE from bluetooth threads
Message-ID: <20070225104447.GK2045@elf.ucw.cz>
References: <200702231116.23607.rjw@sisk.pl> <200702231125.43910.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231125.43910.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-02-23 11:25:42, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove PF_NOFREEZE from the bluetooth threads, adding try_to_freeze() calls as
> required.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
