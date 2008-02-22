Return-Path: <linux-kernel-owner+w=401wt.eu-S933702AbYBVNSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbYBVNSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbYBVNSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:18:46 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54340 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758049AbYBVNSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:18:45 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Jiri Kosina <jkosina@suse.cz>
cc: Anders Eriksson <aeriksson@fastmail.fm>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: lockdep warning 
In-reply-to: <Pine.LNX.4.64.0802221214020.7699@twin.jikos.cz> 
References: <20080222104049.BD95A93C12F@tippex.mynet.homeunix.org> <Pine.LNX.4.64.0802221214020.7699@twin.jikos.cz>
Comments: In-reply-to Jiri Kosina <jkosina@suse.cz>
   message dated "Fri, 22 Feb 2008 12:16:02 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 22 Feb 2008 14:16:08 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080222131608.7FC1E93C12F@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JSXnU-0005nX-4u.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JSXnU-0005nX-4u ac036325e91a96607a8b419063bec3aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



jkosina@suse.cz said:
> This needs to be CCed to netdev.
> Any chance that
> 	git revert 69cc64d8d92
> makes this report go away? 

I'll have to install a git repo to check, or maybe you can send me the diff to 
reverse vs. 2.6.25-rc2?

