Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZEZJ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZEZJ1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZEZJ1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:27:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35770
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058AbZEZJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:27:00 -0400
Date: Tue, 26 May 2009 02:26:59 -0700 (PDT)
Message-Id: <20090526.022659.11431807.davem@davemloft.net>
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 0/7] Blackfin fixes for 2.6.30
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 26 May 2009 05:15:49 -0400

> Sorry for being so late, but our previous Blackfin maintainer has moved
> on, so we've been working at picking up the slack.
> 
> So the stuff here for 2.6.30 is just simple build fixes, gitignore tweaks,
> MAINTAINER updates, and hooking up the new pread syscalls (which was posted
> a while ago already).

Several problems:

1) 10 patches is way too much this late in the 2.6.30 release process.

   Pick 1 or 2 that are the most critical and submit those for 2.6.30,
   the rest get queued up for 2.6.31

2) Networking patches must have netdev@vger.kernel.org at least
   CC:'d so that your patches get properly traced at:

   http://patchwork.ozlabs.org/project/netdev/list/

Thank you.
