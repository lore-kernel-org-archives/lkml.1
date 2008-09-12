Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYILOXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYILOXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYILOXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:23:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4939 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752724AbYILOXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:23:05 -0400
Date: Fri, 12 Sep 2008 16:22:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Milan Broz <mbroz@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [patch 00/42] 2.6.26-stable review
Message-ID: <20080912142251.GA6028@ucw.cz>
References: <20080903172447.GA7731@suse.de> <20080904023905.GA1071@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904023905.GA1071@khazad-dum.debian.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-09-03 23:39:05, Henrique de Moraes Holschuh wrote:
> What about this one:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
> 
> "ACPI: Fix thermal shutdowns" ?
> 
> It should have been submitted to stable@k.o well before 2.6.26.3, but it
> wasn't for some stupid reason.  Then some of us noticed it was missing in
> 2.6.26.3, and gave everyone a head's up, but it was too late for 2.6.26.3.
> 
> And now it also apparently failed to make it to 2.6.26.4?
> 
> As far as I recall, without this patch, all X6* ThinkPads that are not in
> absolute top-notch thermal condition heat up until they are forced to
> shutdown due to overtemperature (thus, slowly further damaging hardware that
> is not in good shape to begin with).
> 
> Greg, is there any way to include the above patch for 2.6.26.4?



Agreed. This patch makes thinkpads unusable... and it was actually
included in 2.6.26.2...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
