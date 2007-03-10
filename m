Return-Path: <linux-kernel-owner+w=401wt.eu-S1751260AbXCJWQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbXCJWQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbXCJWQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:16:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42600 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbXCJWQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:16:44 -0500
Date: Sat, 10 Mar 2007 23:16:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to disk bug 2.6.21-rc2-git1
Message-ID: <20070310221639.GC2674@elf.ucw.cz>
References: <20070305132331.GF3693@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305132331.GF3693@mail.muni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm not sure what version did exacly caused susped to disk problems but
> anyway, in 2.6.21-rc2-git1, suspend to disk breaks ACPI. ACPI events do not
> even emit ACPI interrupts. Suspend to ram works nicely.

Is 2.6.21-latest better?  There were many problems in suspend area,
hopefully they are slowly being fixed...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
