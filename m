Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbXJBUC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbXJBUC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXJBUCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:02:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34314 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbXJBUCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:02:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: shutdown -h now, 2.6.23-rc8 & 9
Date: Tue, 2 Oct 2007 22:16:54 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200710020650.02613.gene.heskett@gmail.com>
In-Reply-To: <200710020650.02613.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022216.54662.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 2 October 2007 12:50, Gene Heskett wrote:
> Greetings everybody;
> 
> After seeing a message indicating that rc8 no longer did a powerdown, I 
> thought I'd check that since I needed to, my tv card wasn't even showing up 
> in the lspci report. It was partially backed out of the pci slot, this case 
> seems to encourage that.
> 
> Indeed it went to the system halted message and just sat there.  I hadn't yet 
> booted to rc9 as amanda was running, so I did just a few minutes ago.
> 
> After the reboot to rc9, I ran a make xconfig again to check that the option 
> was enabled, but it seems to have disappeared from the menus in xconfig.
> 
> Why was this removed?  Or if moved, where to?

Hm, which option?

Greetings,
Rafael
