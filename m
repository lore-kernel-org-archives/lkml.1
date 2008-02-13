Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbYBMIzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbYBMIzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYBMIyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:54:50 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:48487
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbYBMIyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:54:49 -0500
X-DKIM: Sendmail DKIM Filter v2.4.0 alice.et.bocholt.fh-gelsenkirchen.de m1D8sAlp011157
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
Date: Wed, 13 Feb 2008 09:54:09 +0100
Message-ID: <1572.1202892849@sora.hank.home>
From: Dirk GOUDERS <hank@et.bocholt.fh-gelsenkirchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hm, so, to summarize:
>   - you needed this option many years ago to get a box to work properly
>   - you don't need this today

I would summarize:

    - ide=reverse solved certain problems and I am not sure if there are
      users who still need this option

> So, if the option went away, you would not be inconvenienced?

I remember that the disks of the old box are still in a drawer and today,
I will try to reanimate the system and see if grub's ability to map
drives helps to boot the system without ide=reverse.  I'll report later.

Dirk
