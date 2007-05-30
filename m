Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbXE3NH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbXE3NH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXE3NHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:07:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:38832 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXE3NHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:07:16 -0400
X-IronPort-AV: i="4.14,593,1170651600"; 
   d="scan'208"; a="40530842:sNHT24273766398"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
Date: Wed, 30 May 2007 09:09:13 -0400
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <bryan.wu@analog.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <11803414753217-git-send-email-bryan.wu@analog.com> <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300909.13419.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 30 May 2007 13:06:34.0295 (UTC) FILETIME=[593AAC70:01C7A2BB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29 May 2007 16:59, Linus Torvalds pondered:
> 
> On Mon, 28 May 2007, Bryan Wu wrote:
> > 
> >  - Blackfin arch update including BF54x initial supporting
> >  - Blackfin driver update: serial/spi/rtc
> >  - Provide new Blackfin watchdog driver
> >  - binfmt_flat.c for Blackfin arch modification
> 
> I realize that this all just touches blackfin-specific stuff, but after 
> -rc3 I really prefer not to bother with these things..
> 
> Also, for stuff that is really just an architecture that I can't even 
> test,

In one of my (how did Andrew word it...) circumlocutious threads about 
Blackfin a while ago, I offered hardware to anyone who wanted to try things 
out. Greg KH was the only person who read through the entire thing, and asked 
(and got one). Offer still good for qualified developers.

-Robin
