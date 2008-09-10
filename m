Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYIJX7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYIJX7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYIJX7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:59:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49234
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbYIJX7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:59:37 -0400
Date: Wed, 10 Sep 2008 16:59:31 -0700 (PDT)
Message-Id: <20080910.165931.187028031.davem@davemloft.net>
To: kaos@ocs.com.au
Cc: kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: Recent copy of libpcap from CVS 
From: David Miller <davem@davemloft.net>
In-Reply-To: <7381.1221091028@ocs10w>
References: <20080910.155706.100960963.davem@davemloft.net>
	<7381.1221091028@ocs10w>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Owens <kaos@ocs.com.au>
Date: Thu, 11 Sep 2008 09:57:08 +1000

> Comparing git://git.kernel.org/pub/scm/linux/kernel/git/davem/libpcap.git
> against Patrick's tarball.  git is missing some mode and some rcsid
> lines like this example below, I assume that the removal of these lines
> in git was deliberate.

Yes, look at the changesets in the tree, I did it.
