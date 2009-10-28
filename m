Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZJ1Jdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZJ1Jdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbZJ1Jdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:33:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34896
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757264AbZJ1Jdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:33:36 -0400
Date: Wed, 28 Oct 2009 02:34:00 -0700 (PDT)
Message-Id: <20091028.023400.66405237.davem@davemloft.net>
To: dhananjay.phadke@qlogic.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] netxen: fix builds for SYSFS=n or MODULES=n
From: David Miller <davem@davemloft.net>
In-Reply-To: <7608421F3572AB4292BB2532AE89D5658B0B8903CB@AVEXMB1.qlogic.org>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
	<20091026150945.3f35a811.randy.dunlap@oracle.com>
	<7608421F3572AB4292BB2532AE89D5658B0B8903CB@AVEXMB1.qlogic.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhananjay Phadke <dhananjay.phadke@qlogic.com>
Date: Tue, 27 Oct 2009 15:09:24 -0700

> Sorry, seems like I am keeping you busy with the build errors.
> Thanks for fixing it again (may be I need to setup all different build configs).
> 
> Acked-by: Dhananjay Phadke <dhananjay@netxen.com>

Please adhere to the following netiquette when replying to
patches:

1) DO NOT TOP POST.

   You can feel free to continue doing this, but I am warning you
   that soon a day will come when replying to postings in a top-post
   manner will have your posting completely rejected from the list.

   This is absolutely the largest pet peeve amongst kernel developers.
   Quote only the relevant parts of the message, nothing more, and
   then afterwards you place your comments.  Do not add comments
   before the quoted material.  People need to read the quoted part to
   gain the context necessary to understand your reply, not the other
   way around.

2) Do not quote the patch when just adding your ACK or signoff.

   That makes the patch appear twice in patchwork, making more work
   for me and confusion for the patch submitted.

Thank you.
