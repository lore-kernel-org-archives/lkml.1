Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbXJBHKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbXJBHKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXJBHKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:10:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33370 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXJBHKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:10:23 -0400
Date: Tue, 2 Oct 2007 09:10:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, rjw@sisk.pl
Subject: Re: [PATCH] Add Documentation/power/00-INDEX
Message-ID: <20071002071022.GA29559@atrey.karlin.mff.cuni.cz>
References: <200710012244.46869.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710012244.46869.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rob Landley <rob@landley.net>
> 
> Add Documentation/power/00-INDEX
> 
> Signed-off-by: Rob Landley <rob@landley.net>

Looks mostly ok.

> +swsusp.txt
> +	- Goals, implementation, and usage of software suspend (ACPI S3)

But please delete (ACPI S3) remark. It is ACPI S4, if anything.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
