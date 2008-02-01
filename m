Return-Path: <linux-kernel-owner+w=401wt.eu-S935066AbYBABIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbYBABIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYBABIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:08:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52670
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYBABIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:08:38 -0500
Date: Thu, 31 Jan 2008 17:08:59 -0800 (PST)
Message-Id: <20080131.170859.188828281.davem@davemloft.net>
To: 12o3l@tiscali.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][net/sched/sch_teql.c] duplicate IFF_BROADCAST in
 FMASK, remove 2nd
From: David Miller <davem@davemloft.net>
In-Reply-To: <47A08B7C.9010205@tiscali.nl>
References: <47A08B7C.9010205@tiscali.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>
Date: Wed, 30 Jan 2008 15:36:44 +0100

> Untested patch below, please confirm it's the right fix (should it be some
> other IFF_*?)
> --
> duplicate IFF_BROADCAST, remove 2nd
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Applied, thanks.
