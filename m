Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbZABSAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbZABSAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZABR76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:59:58 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:53219 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447AbZABR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:59:57 -0500
Date: Fri, 2 Jan 2009 19:01:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090102180134.GB5818@uranus.ravnborg.org>
References: <200901020207.30359.rob@landley.net> <20090102095023.GA28078@linux-sh.org> <20090102172540.GE8858@knossos.aleph1.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102172540.GE8858@knossos.aleph1.co.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wookey.

> Given the
> simplicitly of these patches I can't see any reason not to put them
> in

Please do NOT do the mistake and think this the same thing.

Rob's patch simplyfy the timecost stuff - and will be applied on
this merit alone assuming comments will be addressed.

But the serie rased anohter topic: shall we ban use of perl
for generating a kernel.
And this is what primary is discussed and the outcome of
that discussion will not prevent patches that stands on their
own to be applied.

	Sam
