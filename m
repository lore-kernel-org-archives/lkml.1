Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXA0VQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXA0VQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbXA0VQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:16:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55045 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbXA0VQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:16:08 -0500
Message-ID: <45BBC10C.5010103@garzik.org>
Date: Sat, 27 Jan 2007 16:15:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: Luca Tettamanti <kronos.it@gmail.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, csnook@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/4] atl1: Ancillary C files for Attansic L1 driver
References: <20070121210737.GE2702@osprey.hogchain.net> <20070121183151.4be61ebf.randy.dunlap@oracle.com> <45B43093.6060500@bellsouth.net> <20070122200004.GA12553@dreamland.darkstar.lan> <20070123112522.65aac61b@freekitty> <20070123211917.GA22109@dreamland.darkstar.lan> <45BBBDD0.7030809@bellsouth.net>
In-Reply-To: <45BBBDD0.7030809@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> Jeff, shall I add this to the larger patch I'm working on for submittal 
> later this weekend, or do you just add it directly to netdev?  (I prefer 
> to do the former if it's okay with you.)

As a driver maintainer, you need to patch sets, and submit them in a 
timely fashion to me.  Note I said patch set, not patch, in following 
with Rule #3 from Documentation/SubmittingPatches.  Also make sure to 
review http://linux.yyz.us/patch-format.html

	Jeff


