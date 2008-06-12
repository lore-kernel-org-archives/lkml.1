Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbYFLNOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbYFLNOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762002AbYFLNOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:14:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4199 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761984AbYFLNN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:13:59 -0400
Date: Thu, 12 Jun 2008 15:13:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH - supplement] PM: Remove remaining obsolete definitions from pm.h (was: Re: [PATCH 0/4] Remove some obsolete PM stuff)
Message-ID: <20080612131347.GE5455@ucw.cz>
References: <200806121025.24668.rjw@sisk.pl> <200806121126.27862.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806121126.27862.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-12 11:26:27, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove the remaining obsolete definitions from
> include/linux/pm.h and move the definitions of PM_SUSPEND and
> PM_RESUME to the header of h3600 which is the only user of them.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.. and thanks for doing the cleanups.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
