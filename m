Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbXCKW3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbXCKW3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbXCKW3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:29:48 -0400
Received: from outpost.ds9a.nl ([213.244.168.210]:45660 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589AbXCKW3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:29:47 -0400
Date: Sun, 11 Mar 2007 23:29:46 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu   scheduler
Message-ID: <20070311222945.GA8242@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con,

Recent kernel versions have real problems for me on the interactivity front,
with even a simple 'make' of my C++ program (PowerDNS) causing Firefox to
slow down to a crawl.

RSDL fixed all that, the system is noticeably snappier.

As a case in point, I used to notice when a compile was done because the
system stopped being sluggish.

Today, a few times, I only noticed 'make' was done because the fans of my
computer slowed down.

Thanks for the good work! I'm on 2.6.21-rc3-rsdl-0.29.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
