Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbXCPN6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbXCPN6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933916AbXCPN6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:58:23 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:36218 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933860AbXCPN6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:58:22 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: RSDL development plans
Date: Sat, 17 Mar 2007 00:59:54 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703162325.05691.kernel@kolivas.org> <1174052523.8039.7.camel@Homer.simpson.net>
In-Reply-To: <1174052523.8039.7.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170059.54320.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 00:42, Mike Galbraith wrote:
> On Fri, 2007-03-16 at 23:25 +1100, Con Kolivas wrote:
> > The good news is that in order to stay sane I've found ways of optimising
> > my computing position and could work for short stints on the rsdl code.
> > So I'll be releasing a new version shortly.
>
> Can you please make an incremental diff as well?  That will make it
> easier to see what changes have taken place, and make it easier to
> integrate those into hacked-upon trees.

They're already there in the subdirs.
ie
http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3/2.6.20.3-rsdl-0.30-0.31.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3/2.6.21-rc3-rsdl-0.30-0.31.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2/2.6.21-rc3-mm2-rsdl-0.30-0.31.patch

> 	-Mike

-- 
-ck
