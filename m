Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZI1Trk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZI1Trk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZI1Trj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:47:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39641
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbZI1Trj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:47:39 -0400
Date: Mon, 28 Sep 2009 12:47:58 -0700 (PDT)
Message-Id: <20090928.124758.05417667.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       keil@b1-systems.de, netdev@vger.kernel.org
Subject: Re: [PATCH] isdn: fix netjet/isdnhdlc build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090928092520.b6f921de.randy.dunlap@oracle.com>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	<20090928092520.b6f921de.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 28 Sep 2009 09:25:20 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Commit cb3824bade2549d7ad059d5802da43312540fdee didn't fix this problem.
> 
> Fix build errors in netjet, using isdnhdlc module:
...
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Since Karsten has been unresonspive to ISDN stuff for weeks,
I'm going to apply this directly.

Thanks!
