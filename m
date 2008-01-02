Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYABNKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYABNKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYABNKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:10:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYABNKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:10:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhenyu Wang <zhenyu.z.wang@intel.com>
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
Date: Wed, 2 Jan 2008 14:12:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200801012202.57851.rjw@sisk.pl> <20080102031205.GA10794@zhen-devel.sh.intel.com>
In-Reply-To: <20080102031205.GA10794@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021412.07313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Zhenyu Wang wrote:
> On 2008.01.01 22:02:57 +0000, Rafael J. Wysocki wrote:
> > Subject		: linux-2.6.24-rcX regression / xserver-xorg-video-intel / Q35
> > Submitter	: Harald Welte <laforge@gnumonks.org>
> > Date		: 2007-12-22 04:37
> > References	: http://lkml.org/lkml/2007/12/21/269
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9618
> > Handled-By	: Zhenyu Wang <zhen78@gmail.com>
> > Patch		: 
> 
> This is resolved by turning on CONFIG_DMAR_GFX_WA.

OK, I have removed it from the list.

Thanks,
Rafael
