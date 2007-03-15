Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbXCOHxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbXCOHxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXCOHxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:53:11 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:43444 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751479AbXCOHxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:53:10 -0400
Subject: Re: NPTL patch for linux 2.4.28
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Syed Ahemed <kingkhan@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, msnyder@redhat.com,
       jjohnstn@redhat.com
In-Reply-To: <3d53b7120703141444k6484ccfeyd08cf60ecbbb894a@mail.gmail.com>
References: <3d53b7120703131719y7bac2dccpb7bf8e32f7d45768@mail.gmail.com>
	 <20070314055556.GP943@1wt.eu>
	 <3d53b7120703141444k6484ccfeyd08cf60ecbbb894a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 08:53:06 +0100
Message-Id: <1173945186.25356.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 03:14 +0530, Syed Ahemed wrote:

> Getting RHEL's source ( http://lkml.org/lkml/2005/3/21/380 ) was an
> idea i thought about but then a download of the RHEL source from the
> following location was denied .
> http://download.fedora.redhat.com/pub/fedora/linux/core/1/SRPMS/  and
> the rpmfind site.
> (Guess need to be a paid subscriber for that right ?)

Strangely enough you try to download Fedora Core SRPMs whilst you speak
of RHEL. Try this one:

ftp://ftp.redhat.com/pub/redhat/linux/enterprise/3/en/os/i386/SRPMS/kernel-2.4.21-4.EL.src.rpm

Also, CentOS would have similar sources. Google could have informed you
on that.

> I still wonder why there aren't any NPTL patches available in the
> non-redhat sites for kernels like 2.4.21 or more .

Because most people, especially the ones on this mailing list have moved
on to 2.6 quite some time ago. May I suggest you do the same?

