Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYGCUoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYGCUoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYGCUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:44:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57828
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbYGCUoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:44:17 -0400
Date: Thu, 03 Jul 2008 13:44:16 -0700 (PDT)
Message-Id: <20080703.134416.115438394.davem@davemloft.net>
To: gregkh@suse.de
Cc: jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: fix up bus_id changes in sparc core code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080703164939.GA13326@suse.de>
References: <20080702153651.GB30318@kroah.com>
	<20080703.033556.167121752.davem@davemloft.net>
	<20080703164939.GA13326@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Thu, 3 Jul 2008 09:49:39 -0700

> Argh, I'm patching against a previous patch that was only sent to Jesse
> for the PCI core, sorry for the confusion.
> 
> The patch for that is below.  It's probably easier for Jesse to take
> both of these in his tree if you like, or I can send you just the Sparc
> one, based on HEAD right now, and then the intermediate step in the PCI
> patch would not be needed.
> 

It's easiest if Jesse takes them both, here is my ACK:

Acked-by: David S. Miller <davem@davemloft.net>
