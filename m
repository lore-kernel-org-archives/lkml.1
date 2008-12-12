Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYLLFLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYLLFLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYLLFLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:11:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34731
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbYLLFLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:11:35 -0500
Date: Thu, 11 Dec 2008 21:11:36 -0800 (PST)
Message-Id: <20081211.211136.33086862.davem@davemloft.net>
To: gregkh@suse.de
Cc: s.L-H@gmx.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       rolandd@cisco.com, jgarzik@redhat.com
Subject: Re: [patch 03/83] cxgb3: Fix kernel crash caused by uninitialized
 l2t_entry.arpq
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081212040052.GA9561@suse.de>
References: <20081211191334.GC5894@kroah.com>
	<200812112212.35832.s.L-H@gmx.de>
	<20081212040052.GA9561@suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Thu, 11 Dec 2008 20:00:52 -0800

> David, I'm going to have to drop the original patch you sent me here, as
> it doesn't build in the 2.6.27 tree.  If you have a replacement for it
> that does build, I'll be glad to take it.

As I replied already, this is fine, sorry for the
misfire :-)
