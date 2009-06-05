Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZFESri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZFESri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZFESra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:47:30 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:40494 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZFESra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:47:30 -0400
From: "Michael S. Zick" <mszick@morethan.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8
Date: Fri, 5 Jun 2009 13:47:26 -0500
User-Agent: KMail/1.9.9
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051347.29646.mszick@morethan.org>
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

Today's test build for VIA powered NetBooks is posted (as -09156):
Details at:
http://forum.netbookuser.com/viewtopic.php?pid=7043#p7043

Summary:
Yesterday's (last night's, this morning's) record holder (9+ hours)
plus the changes proposed by Dave Jones and Bob Copeland.

Mike
