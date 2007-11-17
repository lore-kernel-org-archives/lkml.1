Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbXKQHpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbXKQHpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 02:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXKQHoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 02:44:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35530 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXKQHox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 02:44:53 -0500
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
From: Peter Zijlstra <peterz@infradead.org>
To: Dane Mutters <dmutters@gmail.com>
Cc: Martin Olsson <mnemo@minimum.se>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ubuntu Devel Discuss <ubuntu-devel-discuss@lists.ubuntu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1195281942.15929.5.camel@Orchestrator>
References: <473E815F.30900@minimum.se>
	 <20071116213137.6efe3f9e@the-village.bc.nu>  <473E9290.3040006@minimum.se>
	 <1195281942.15929.5.camel@Orchestrator>
Content-Type: text/plain
Date: Sat, 17 Nov 2007 08:44:41 +0100
Message-Id: <1195285481.3059.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-16 at 22:45 -0800, Dane Mutters wrote:
> I thought you might find this helpful.  (I brought this issue up with
> the Slackware folks once, and they told me basically this.)
> 
> http://wiki.craz1.homelinux.com/index.php/Linux:Security:Forkbomb
> 
> I was also told that the ability to spawn such rampant forks/processes
> is controlled by default in Debian.  Is this the case?
> 
> Here is an LQ thread where I brought it up:
> 
> http://www.linuxquestions.org/questions/linux-security-4/how-can-i-prevent-forkbombs-338560/
> 
> I would like to see something done about this, with Ubuntu as popular as
> it is, even as a server in some cases.  Is there a way that in the
> future, one could simply download a package or click a box or something
> and have a limit set, like the links suggest?  That would make things
> just "that much" more convenient for system administrators (and might
> help them/us to remember to set these limits, too...).

If you don't know which limits to set and need a package for them, your
job title should not be system administrator.



