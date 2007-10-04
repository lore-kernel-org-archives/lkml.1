Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbXJDKUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbXJDKUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbXJDKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:20:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56282 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757760AbXJDKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:20:46 -0400
Date: Thu, 4 Oct 2007 12:19:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: mention bitfields/whitespace style, prefer (!foo)
	in examples
Message-ID: <20071004101901.GK22940@elf.ucw.cz>
References: <20071004094422.GA652@elf.ucw.cz> <Pine.LNX.4.64.0710041151120.7253@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710041151120.7253@fbirervta.pbzchgretzou.qr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-10-04 11:51:35, Jan Engelhardt wrote:
> 
> On Oct 4 2007 11:44, Pavel Machek wrote:
> >diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> >index 7f1730f..1595a45 100644
> >--- a/Documentation/CodingStyle
> >+++ b/Documentation/CodingStyle
> >@@ -71,6 +71,15 @@ used for indentation, and the above exam
> > 
> > Get a decent editor and don't leave whitespace at the end of lines.
> > 
> >+Bitfield variables should be indented like this:
> >+
> >+	unsigned int foo :1;
> 
> Current code uses foo:1.

I'm fine with foo :1 or foo:1. It just would be nice to have example
specifying one way...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
