Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYIOXPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYIOXPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 19:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbYIOXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 19:15:34 -0400
Received: from elvis.franken.de ([193.175.24.41]:50934 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbYIOXPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 19:15:34 -0400
X-Greylist: delayed 4935 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2008 19:15:33 EDT
Date: Mon, 15 Sep 2008 23:53:08 +0200
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080915215307.GA10340@alpha.franken.de>
References: <20080915201749.GB3994@havoc.gtf.org> <20080915.132716.267218808.davem@davemloft.net> <20080915204543.GD3994@havoc.gtf.org> <20080915.141442.139271313.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915.141442.139271313.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 02:14:42PM -0700, David Miller wrote:
> Most of those changes were complete and utter CRAP.

thank you, but the fix I've sent (de2104x) isn't crap. The bug breaks the 
current debian-installer for Cobalt Qube1, when it tries to get an
IP address via dhcp. 

In my eyes it's a clean and good fix, but I don't care whether it appears
in 2.6.27 or 2.6.28, because debian needs to backport it to 2.6.26
anyway. But declaring bugfixes, which just fixes an very old bug, as
utter crap isn't really nice.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
