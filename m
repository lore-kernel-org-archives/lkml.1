Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYFSXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYFSXLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYFSXLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 19:11:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34756
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbYFSXLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 19:11:08 -0400
Date: Thu, 19 Jun 2008 16:11:08 -0700 (PDT)
Message-Id: <20080619.161108.23678497.davem@davemloft.net>
To: wcong@critical-links.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru
Subject: Re: [Patch] net/sched/sch_generic.c: fix an error pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080619153714.5614d5be@hack>
References: <20080619153714.5614d5be@hack>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <wcong@critical-links.com>
Date: Thu, 19 Jun 2008 15:37:14 +0100

> ERR_PTR() ususally encodes an negative errno, not positive.
> 
> Note, in the following patch, 'err' is initialized as:
> 
> int err = -ENOBUFS;
> 
> Signed-off-by: WANG Cong <wcong@critical-links.com>

Patch is whitespace corruped and line wrapped by your
email client.

Please fix this and resubmit, thank you.
