Return-Path: <linux-kernel-owner+w=401wt.eu-S1761841AbXF1Oss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbXF1Oss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbXF1Osl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:48:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2976 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752289AbXF1Osk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:48:40 -0400
Date: Thu, 28 Jun 2007 14:23:31 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 0/3] integrity: Linux Integrity Module(LIM) and provider
Message-ID: <20070628142330.GB5339@ucw.cz>
References: <1182199230.8577.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182199230.8577.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is a request for comments for a subset of the original integrity
> patches. By submitting this subset of the original patches, we hope to
> simplify its review and ultimately ease its inclusion into the kernel.

We still don't know what these are good for...

...preventing user from taking out hdd and modifying binaries?

...if user can do that, why is he unable to remove the lim.ko, too?

TPM?

Why this won't be abused to prevent me from playing with hardware I
own?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
