Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbXDIGGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbXDIGGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 02:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXDIGGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 02:06:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:59441 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752984AbXDIGGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 02:06:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Rt/xyWfdRkz7xj3dBc46QffLbbH/g7Ewz2m3gIq
	OMfTZbnBS72/Hk
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704090116.37329.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704081356.48843.gene.heskett@gmail.com>
	 <1176092271.6355.16.camel@Homer.simpson.net>
	 <200704090116.37329.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 08:06:08 +0200
Message-Id: <1176098768.6355.114.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 01:16 -0400, Gene Heskett wrote:
> On Monday 09 April 2007, Mike Galbraith wrote:
> >So tar -cvf - / | gzip --best | tar -tvzf - should reproduce the
> >problem?
> >
> >	-Mike
> 
> That looks as if it should demo it pretty well if I understand correctly 
> everything you're doing there.

Well, I let it process my ~250GB of data with my current tree, and it
looked utterly harmless (and since I'm running SMP, was of course).
I'll try building UP to make sure, and check mainline as well.

	-Mike

