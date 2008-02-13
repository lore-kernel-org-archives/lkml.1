Return-Path: <linux-kernel-owner+w=401wt.eu-S1764726AbYBMAs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764726AbYBMAs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYBMAsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:48:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59450 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYBMAsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:48:45 -0500
Date: Wed, 13 Feb 2008 00:48:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213004841.GM27894@ZenIV.linux.org.uk>
References: <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212.155107.251983955.davem@davemloft.net> <20080212235401.GL27894@ZenIV.linux.org.uk> <20080213001650.GY18625@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213001650.GY18625@fieldses.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 07:16:50PM -0500, J. Bruce Fields wrote:
> > Ahem...  Use of git-cherry-pick preserves commit information just fine.
> 
> Not by default, at least (note they said "commiters", not "authors"):

That's why you give it -r.
