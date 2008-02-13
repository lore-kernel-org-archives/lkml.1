Return-Path: <linux-kernel-owner+w=401wt.eu-S1764536AbYBMUBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbYBMUBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbYBMUBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:01:23 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:34652
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbYBMUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:01:21 -0500
X-DKIM: Sendmail DKIM Filter v2.4.0 alice.et.bocholt.fh-gelsenkirchen.de m1DK0J2O005920
To: Greg KH <greg@kroah.com>
cc: bzolnier@gmail.com, muli@il.ibm.com, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jdmason@kudzu.us, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [discuss] "ide=reverse" do we still need this? 
In-reply-to: <20080213082643.GB14098@kroah.com> 
References: <20080213001506.GA13933@kroah.com> <1237.1202889295@sora.hank.home> <20080213082643.GB14098@kroah.com>
Comments: In-reply-to Greg KH <greg@kroah.com>
   message dated "Wed, 13 Feb 2008 00:26:43 -0800."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.1.1
Date: Wed, 13 Feb 2008 21:00:15 +0100
Message-ID: <3138.1202932815@sora.hank.home>
From: Dirk GOUDERS <hank@et.bocholt.fh-gelsenkirchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hm, so, to summarize:
>   - you needed this option many years ago to get a box to work properly
>   - you don't need this today
> 
> So, if the option went away, you would not be inconvenienced?

After having reanimated the old system and after comments of other
persons I would not be inconvenienced if the option went away.

The system indeed did not boot correctly without that option, because
the disks appeared in a wrong order.  On the other hand, I was able to
(re)install bootloaders (grub as well as lilo) and after that did not
need the option any more.  Unfortunately, after that I was not able to
reproduce the initial situation where the option was needed.

Dirk
