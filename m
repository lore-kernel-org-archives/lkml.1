Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbYLPEML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYLPEML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 23:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYLPEL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 23:11:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45404 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYLPEL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 23:11:56 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: mmotm 2008-12-15-16-45 uploaded (build errors)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <494726DE.6000100@oracle.com>
References: <200812160046.mBG0k0YV024823@imap1.linux-foundation.org> <494726DE.6000100@oracle.com>
Message-Id: <20081216131105.DB9A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 13:11:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2008-12-15-16-45 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.28-rc8:
> 
> 
> Summary of build errors:
> 
> i386
> =====
> build-r7178.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
> build-r7178.out:make[2]: *** [mm/vmscan.o] Error 1

I think my fault.
I'll investigate soon.




