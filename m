Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYAZJnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYAZJnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYAZJm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:42:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2052 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753106AbYAZJm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:42:56 -0500
Date: Sat, 26 Jan 2008 09:42:40 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Q: x86 suspend/hibernation code consolidation
Message-ID: <20080126094239.GA4096@ucw.cz>
References: <200801260132.09529.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801260132.09529.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'd like to move the 64-bit suspend/hibernation files from arch/x86/kernel to
> arch/x86/power, modify the names of the 32-bit files already in
> arch/x86/power and update the Makefiles accordingly, but there are some changes
> queued for merging that touch the files in question.

I have similar patch producing hibernation_*.S, I can send it as a
base. Moving it soon  would be nice :-).

As I'm in process of rewriting arch/x86/kernel/acpi/ , I'd prefer that
not to be moved from under me.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
