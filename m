Return-Path: <linux-kernel-owner+w=401wt.eu-S934902AbXG3MO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902AbXG3MO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759836AbXG3MOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:14:51 -0400
Received: from namei.org ([69.55.235.186]:41438 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758913AbXG3MOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:14:50 -0400
X-Greylist: delayed 1585 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 08:14:50 EDT
Date: Mon, 30 Jul 2007 04:47:06 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] security/ cleanups
In-Reply-To: <20070729150059.GN16817@stusta.de>
Message-ID: <Pine.LNX.4.64.0707300446230.14829@us.intercode.com.au>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
 <20070729150059.GN16817@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007, Adrian Bunk wrote:

> This patch contains the following cleanups that are now possible:
> - remove the unused security_operations->inode_xattr_getsuffix
> - remove the no longer used security_operations->unregister_security
> - remove some no longer required exit code
> - remove a bunch of no longer used exports
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
