Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0AOOBV (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644Ab0AOOBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:01:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:52045 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639Ab0AOOBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:01:17 -0500
Date: Fri, 15 Jan 2010 15:01:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, sameo@linux.intel.com,
        Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] typo in kernel source (DEBUGFS)
In-Reply-To: <63386a3d1001140207p5e2546fq2d8201ee87edfd46@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1001151500460.15694@twin.jikos.cz>
References: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de> <63386a3d1001140207p5e2546fq2d8201ee87edfd46@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Linus Walleij wrote:

> 2010/1/13 Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>:
> 
> >        While working on this we detected a spelling error in
> > drivers/mfd/ab3100-otp.c which can be corrected using the attached
> > patch.
> 
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>

The original patch misses a Signed-off-by. Please resend it to 
trivial@kernel.org with this line, so that it could be applied.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

