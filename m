Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbXHXVBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbXHXVBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762007AbXHXVBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:01:03 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46191 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757259AbXHXVBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:01:00 -0400
Date: Fri, 24 Aug 2007 10:13:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] ACPI: Clean up acpi_enter_sleep_state_prep
Message-ID: <20070824081305.GA2175@elf.ucw.cz>
References: <200708221156.36235.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708221156.36235.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-08-22 11:56:35, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove some redundant code from acpi_enter_sleep_state_prep() and clean up
> a comment in there.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
