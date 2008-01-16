Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYAPMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYAPMZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYAPMZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:25:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59846
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbYAPMZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:25:19 -0500
Date: Wed, 16 Jan 2008 04:25:07 -0800 (PST)
Message-Id: <20080116.042507.164140347.davem@davemloft.net>
To: slavon@bigtelecom.ru
Cc: elendil@planet.nl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
From: David Miller <davem@davemloft.net>
In-Reply-To: <478DC824.4030600@bigtelecom.ru>
References: <200801150625.10823.elendil@planet.nl>
	<20080114.215317.38045859.davem@davemloft.net>
	<478DC824.4030600@bigtelecom.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Badalian Vyacheslav <slavon@bigtelecom.ru>
Date: Wed, 16 Jan 2008 12:02:28 +0300

> applied to 2.6.24-rc7-git2
> Have messages
> Also have regression after apply patch.
> System may do above 800mbs traffic before patch. After its "exit polling 
> mode?" (4 CPU, 1 cpu get 100% si (process ksoftirqd/0), 3 CPU is IDLE)
> After patch system was go to "exit polling mode" at above 600mbs.

What do you mean by 'system was go to "exit polling mode"'?

Please be more clear about your situation, in particular
provide every detail about what happens so that we can
properly debug this.

THanks.
