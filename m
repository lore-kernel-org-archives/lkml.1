Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYIKAPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYIKAPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYIKAPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:15:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43089
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbYIKAPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:15:44 -0400
Date: Wed, 10 Sep 2008 17:15:38 -0700 (PDT)
Message-Id: <20080910.171538.129595030.davem@davemloft.net>
To: kaos@ocs.com.au
Cc: kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: Recent copy of libpcap from CVS 
From: David Miller <davem@davemloft.net>
In-Reply-To: <8686.1221091795@ocs10w>
References: <20080910.165931.187028031.davem@davemloft.net>
	<8686.1221091795@ocs10w>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Owens <kaos@ocs.com.au>
Date: Thu, 11 Sep 2008 10:09:55 +1000

> David Miller (on Wed, 10 Sep 2008 16:59:31 -0700 (PDT)) wrote:
> >From: Keith Owens <kaos@ocs.com.au>
> >Date: Thu, 11 Sep 2008 09:57:08 +1000
> >
> >> Comparing git://git.kernel.org/pub/scm/linux/kernel/git/davem/libpcap.git
> >> against Patrick's tarball.  git is missing some mode and some rcsid
> >> lines like this example below, I assume that the removal of these lines
> >> in git was deliberate.
> >
> >Yes, look at the changesets in the tree, I did it.
> 
> Removing the #ifndef lines also accidentally removed a copyright notice.

No, the copyright is also in the comment right above it.
