Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbZAMSOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZAMSOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZAMSOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:14:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbZAMSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:14:06 -0500
Date: Tue, 13 Jan 2009 10:13:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for 2.6-git
In-Reply-To: <20090106221129.GB32689@kroah.com>
Message-ID: <alpine.LFD.2.00.0901131012530.6528@localhost.localdomain>
References: <20090106221129.GB32689@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Greg KH wrote:
>
> Here are some staging patches against your 2.6 git tree, all safe and
> self-contained in the drivers/staging/ portion of the tree.

Ok, I can confirm that the rt2860 driver works and makes newer eeepc's 
useful. But I haven't looked at the sources, since I'm a wuss.

		Linus
