Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZHaE3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZHaE3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 00:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZHaE3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 00:29:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39798
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbZHaE3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 00:29:04 -0400
Date: Sun, 30 Aug 2009 21:29:18 -0700 (PDT)
Message-Id: <20090830.212918.146621489.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: airlied@linux.ie, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       ben@decadent.org.uk, divy@chelsio.com
Subject: Re: linux-next: manual merge of the drm tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090831142105.7c05ae77.sfr@canb.auug.org.au>
References: <20090831142105.7c05ae77.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 31 Aug 2009 14:21:05 +1000

> Hi Dave,
> 
> Today's linux-next merge of the drm tree got a conflict in
> firmware/Makefile between commit 2e8c07c35b3ffee7689406be61fd1448ee45d3cd
> ("cxgb3: use request_firmware() for the EDC registers setup") from the
> net tree and commit ece2be7993cc5e269cbf0cad6442b401a2c31915 ("drm/mga:
> Use request_firmware() to load microcode") from the drm tree.
> 
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

This looks fine, please carry the fix until we all merge this stuff
in during the merge window :-)
