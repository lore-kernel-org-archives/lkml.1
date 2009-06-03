Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZFCM6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZFCM6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZFCM6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:58:13 -0400
Received: from mb1.zcs.datasyncintra.net ([208.88.241.39]:53562 "EHLO
	mb1.zcs.datasyncintra.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZFCM6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:58:12 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 08:58:12 EDT
Date: Wed, 3 Jun 2009 07:51:44 -0500 (CDT)
From: Anand Avati <avati@gluster.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: muirj@nortel.com, csaba@gluster.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dl-hacking@gluster.com
Message-ID: <1119562997.1044731244033504415.JavaMail.root@mb1>
In-Reply-To: <683929306.1044151244033426071.JavaMail.root@mb1>
Subject: Re: [PATCH] fuse: cache invalidation calls
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.0.65]
X-Mailer: Zimbra 5.0.16_GA_2921.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.16_GA_2921.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Miklos Szeredi" <miklos@szeredi.hu> wrote:

> John, thanks for the patch.  If no problems are found I'd like to add
> it to the 2.6.31 queue.
> 
> Csaba, Anand, does this meet your requirements?
> 
> Other comments?

I was wondering how the userland libfuse would be made aware of the presence of these two notification features?

Avati
