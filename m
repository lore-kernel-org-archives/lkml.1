Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbZLRRbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbZLRRbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZLRRbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:31:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1279 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbZLRRbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:31:21 -0500
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105
 chars
From: Joe Perches <joe@perches.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
In-Reply-To: <m3iqc41h83.fsf@intrepid.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain>
	 <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	 <24653.1261110557@localhost> <1261113144.13734.317.camel@Joe-Laptop.home>
	 <m3iqc41h83.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 09:31:19 -0800
Message-ID: <1261157479.24328.25.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 15:37 +0100, Krzysztof Halasa wrote:
> > Add 80 character long line STRICT test
> Not sure what do you mean.

CHK messages are only printed when --strict is on the command line

> This makes perfect sense, at least until shown otherwise (though being
> a warning instead of an error means it's ok to trigger in perfectly
> valid code).

It's a CHK, only printed with --strict.


