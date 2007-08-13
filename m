Return-Path: <linux-kernel-owner+w=401wt.eu-S1033048AbXHMSYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033048AbXHMSYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946852AbXHMSFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:05:19 -0400
Received: from mx2.netapp.com ([216.240.18.37]:57450 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971189AbXHMSFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:05:09 -0400
X-IronPort-AV: E=Sophos;i="4.19,256,1183359600"; 
   d="scan'208";a="92001317"
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Dan Merillat <dan.merillat@gmail.com>,
       Paolo Ornati <ornati@fastwebnet.it>, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <46C09C1A.7050706@googlemail.com>
References: <46C09C1A.7050706@googlemail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Mon, 13 Aug 2007 14:04:41 -0400
Message-Id: <1187028281.6628.46.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Aug 2007 18:04:42.0087 (UTC) FILETIME=[6C2A5F70:01C7DDD4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 19:59 +0200, Michal Piotrowski wrote:

> FS
> 
> Subject         : NFSv4 poops itself
> References      : http://lkml.org/lkml/2007/7/27/144
> Last known good : ?
> Submitter       : Jeff Garzik <jeff@garzik.org> 
> Caused-By       : ?
> Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
> Patch           : http://lkml.org/lkml/2007/7/27/183
> Status          : patch available

A fix for this was merged by Linus prior to the release of 2.6.23-rc3.

Cheers
  Trond
