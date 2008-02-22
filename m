Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYBVQdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYBVQdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759971AbYBVQc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:32:28 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59355 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077AbYBVQcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:32:21 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Jiri Kosina <jkosina@suse.cz>
cc: Anders Eriksson <aeriksson@fastmail.fm>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: lockdep warning 
In-reply-to: <Pine.LNX.4.64.0802221420250.30955@jikos.suse.cz> 
References: <20080222104049.BD95A93C12F@tippex.mynet.homeunix.org> <Pine.LNX.4.64.0802221214020.7699@twin.jikos.cz> <20080222131608.7FC1E93C12F@tippex.mynet.homeunix.org> <Pine.LNX.4.64.0802221420250.30955@jikos.suse.cz>
Comments: In-reply-to Jiri Kosina <jkosina@suse.cz>
   message dated "Fri, 22 Feb 2008 14:20:40 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 22 Feb 2008 17:32:13 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080222163213.5BDE293C12F@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1JSaop-0000bz-6P.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JSaop-0000bz-6P f3b9a182e9f928c1ca527b9914a84f27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


jkosina@suse.cz said:
> > Any chance that
> > 	git revert 69cc64d8d92
> > makes this report go away?  

I've tested the patch and I no longer get that lock thing in my syslog.

/A

