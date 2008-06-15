Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYFOKgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYFOKgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYFOKgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:36:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52254 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYFOKgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:36:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "werner" <werner@copaya.yi.org>
Subject: Re: Regressions in the last kernels
Date: Sun, 15 Jun 2008 12:37:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>
References: <1213483422.8768@copaya.yi.org>
In-Reply-To: <1213483422.8768@copaya.yi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806151237.44345.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't drop the CC list from your replies and please don't top-post.

On Sunday, 15 of June 2008, werner wrote:
> The 2nd problem anyway is present with the 2.6.26-rc5 and -rc4 kernels.
> It was NOT presend with 2.6.25-rc9, at least not on 1 IBM laptop what I had
> before-yesterday, which had the problem with 2.6.26-rc5/4 but not with
> 2.6.25-rc9 (all other config was the same).  It did NOT help change edd from
> off to on, so that is a new problem.   With -rc6, I donk know because I couldnt
> test it yet, the man had gone away with his laptop already.

Okay, so this issue seems to be a recent regression.

> Many people bring me old computers to repair. I always throw out Windows and
> install Linux.  So I see plenty kernel errors. But I dont have time to report them
> all, only some.  And normally I dont have long time the computers because
> later the people come and go away with them computers.              
> 
> I make all my kernel packages for i486 because here in the 3rd world many
> people have old computers ftp://ftp5.gwdg.de/pub/linux/install/sys/   
> However these kernels should work on newer computers too, like on my server
> what has 8 GB memory.  With i486, all the last kernels 2.6.26 cannot be
> configured to more than 4 GB and, running, nor that is working correctly.  

This is intentional, as i486 processors cannot handle more than 4 GB of RAM.

Thanks,
Rafael
