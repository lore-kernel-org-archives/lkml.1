Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZLBVsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZLBVsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbZLBVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:48:41 -0500
Received: from swm.pp.se ([212.247.200.143]:40109 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbZLBVsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:48:40 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 16:48:40 EST
Date: Wed, 2 Dec 2009 22:41:05 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ferenc Wagner <wferi@niif.hu>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
In-Reply-To: <200912022233.16138.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0912022238100.23464@uplift.swm.pp.se>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <87638qw2zy.fsf@tac.ki.iif.hu> <87skbtve5w.fsf@tac.ki.iif.hu> <200912022233.16138.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Rafael J. Wysocki wrote:

> Then I guess we do something that confuses your machine's BIOS or it's a 
> timing-related issue (ie. there has to be a substantial delay between 
> the hibernation and restore to trigger the problem).  Or both.

I don't know if it's related, but on 2.6.31.something (ubuntu 9.10 stock 
kernel) I have intermittent suspend/resume problems on my Thinkpad X200, 
and I get the problems much more frequent when running on batteries than 
when I'm running with the power cable plugged in. Just saying that this 
might be something to test as well.

Link to "my" bug on launchpad:

<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/473876>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
