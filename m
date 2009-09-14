Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZINFBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZINFBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbZINFBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:01:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39936
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbZINFBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:01:07 -0400
Date: Sun, 13 Sep 2009 22:01:24 -0700 (PDT)
Message-Id: <20090913.220124.87952638.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       paul.moore@hp.com, jmorris@namei.org, mst@redhat.com
Subject: Re: linux-next: security-testing/net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090914145623.6cf45f8e.sfr@canb.auug.org.au>
References: <20090914130154.8b6df8f9.sfr@canb.auug.org.au>
	<20090913.214644.164044855.davem@davemloft.net>
	<20090914145623.6cf45f8e.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Sep 2009 14:56:23 +1000

> You might like to send him an email pointing out this merge fix, as when
> he merges your tree, it will fail to build tun ... and, if he is told, he
> can put this fix in the merge commit so there is no bisection breakage.
> This is all presuming that commit
> 89f56d1e91cfa535ccc6cc60e9e12e02682fd972 ("tun: reuse struct sock
> fields") is in the tree you asked him to pull.

Good idea, I'll do that.
