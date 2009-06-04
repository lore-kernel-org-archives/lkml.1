Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbZFDN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbZFDN4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZFDN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:56:12 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:40026 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZFDN4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:56:11 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 08:56:07 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906040856.10512.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue June 2 2009, Linus Torvalds wrote:
> 
> This is almost certainly the last -rc, and I debated even doing it. But 
> rather than just do 2.6.30, I decided that I'd be better off doing a last 
> -rc8 and then a real release probably this weekend.
> 
> This has mostly driver and arch updates, with perhaps the intel drm/kms 
> and network driver changes standing out, but there's powerpc, blackfin and 
> arm updates too. Admittedly, the two biggest parts of the powerpc update 
> are a revert and a defconfig update.
> 
> A lot of small stuff, fixing a few regressions (and at least one bugzilla 
> entry going back to 2.6.24). The small stuff does matter. Please test.
> 
> 		Linus
> 

Today's first 2.6.30-rc8 build for VIA NetBooks is posted.
Details at:
http://forum.netbookuser.com/viewtopic.php?pid=7034#p7034

- - summary - -

This is the kernel.org repository tag: 2.6.30-rc8 codebase ***without*** local patches;
Using the same configuration as the record holding (-09149), variable speed kernel.

The -09149 announcement is at:
http://forum.netbookuser.com/viewtopic.php?pid=7002#p7002
(Note: that build had local patches.)

I have also re-posted the record holding (-09143lk), fixed speed build, see above links.
