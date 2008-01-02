Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYABDH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYABDH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYABDHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:07:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50964
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753417AbYABDHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:07:13 -0500
Date: Tue, 01 Jan 2008 19:07:12 -0800 (PST)
Message-Id: <20080101.190712.216262124.davem@davemloft.net>
To: joonwpark81@gmail.com
Cc: jacliburn@bellsouth.net, jeff@garzik.org, csnook@redhat.com,
       linux-kernel@vger.kernel.org, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, shemminger@linux-foundation.org
Subject: Re: [PATCH 25/26] [REVISED] atl1: add NAPI support
From: David Miller <davem@davemloft.net>
In-Reply-To: <000001c84ceb$18a967c0$47e7a8c0@jason>
References: <1199152804-3889-26-git-send-email-jacliburn@bellsouth.net>
	<20080101121536.3df9c497@osprey.hogchain.net>
	<000001c84ceb$18a967c0$47e7a8c0@jason>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joonwoo Park" <joonwpark81@gmail.com>
Date: Wed, 2 Jan 2008 11:56:36 +0900

> Since we had reached a consensus on fixing it without each drivers
> modifications, there is no best solution for that problem for
> now. I'm expecting Dave or others work for net-core.
> (http://lkml.org/lkml/2007/12/20/600)

Indeed, I really hope to try and close this out very soon.
Sorry for taking so long.
