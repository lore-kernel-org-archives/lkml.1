Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZCGWMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZCGWMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbZCGWMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:12:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbZCGWMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:12:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
Date: Sat, 7 Mar 2009 23:12:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>, eric@anholt.net,
       airlied@linux.ie
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <1236129312.32297.259.camel@rzhang-dt>
In-Reply-To: <1236129312.32297.259.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903072312.10731.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Zhang Rui wrote:
> On Wed, 2009-03-04 at 03:22 +0800, Rafael J. Wysocki wrote:
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12705
> > Subject         : X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
> > Submitter       : Nico Schottelius <nico-linux-20090213@schottelius.org>
> > Date            : 2009-02-13 9:33 (19 days old)
> > References      : http://marc.info/?l=linux-kernel&m=123451768406825&w=4
> > Handled-By      : Len Brown <lenb@kernel.org>
> > 
> 
> e806b4957412bf472d826bd8cc571da041248799 is first bad commit
> commit e806b4957412bf472d826bd8cc571da041248799
> Author: Eric Anholt <eric@anholt.net>
> Date:   Thu Jan 22 09:56:58 2009 -0800
> 
>     drm/i915: Suppress GEM teardown on X Server exit in KMS mode.
>     
>     Fixes hangs when starting X for the second time.
>     
>     Signed-off-by: Eric Anholt <eric@anholt.net>
>     Signed-off-by: Dave Airlie <airlied@linux.ie>
> 
> http://marc.info/?l=linux-kernel&m=123479975503827&w=2

Thanks, updated.

Rafael
