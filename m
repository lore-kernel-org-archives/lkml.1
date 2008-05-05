Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYEEAGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYEEAGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 20:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYEEAGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 20:06:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50974
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbYEEAGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 20:06:11 -0400
Date: Sun, 04 May 2008 17:06:11 -0700 (PDT)
Message-Id: <20080504.170611.112259062.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: monstr@seznam.cz, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       monstr@monstr.eu
Subject: Re: [PATCH 1/2] OF: Fix coding style violation in of_device.c and
 of_platform.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080505095649.fccb57bf.sfr@canb.auug.org.au>
References: <1209824532-7939-1-git-send-email-monstr@seznam.cz>
	<765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
	<20080505095649.fccb57bf.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 5 May 2008 09:56:49 +1000

> Any changes to the drivers of files should be cc'd to me (who did the
> initial splitup) and Dave Miller since you may impact the sparc code
> (which is the other user).

I tried to stitch these patches together and apply them to Linus's
tree for some sparc test builds the other day, but failed.

I can't figure out what this mess is against. :-/
