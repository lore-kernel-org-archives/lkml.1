Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZFVAVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZFVAVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 20:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZFVAUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 20:20:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50402
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbZFVAUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 20:20:48 -0400
Date: Sun, 21 Jun 2009 17:20:52 -0700 (PDT)
Message-Id: <20090621.172052.96417973.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: bzolnier@gmail.com, elendil@planet.nl, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New IDE maintainer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090622100021.a40aa1fd.sfr@canb.auug.org.au>
References: <20090621.155756.100422570.davem@davemloft.net>
	<20090621.161343.181101055.davem@davemloft.net>
	<20090622100021.a40aa1fd.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 22 Jun 2009 10:00:21 +1000

>> I've created a new IDE development tree at:
>> 
>> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git
> 
> So, do I immediately switch linux-next to this tree?  The current tree I
> am using is empty (relative to Linus' tree).

If there's nothing in Bart's tree currently, I don't see why not.
