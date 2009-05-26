Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZEZWOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZEZWOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbZEZWON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:14:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56953
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755080AbZEZWOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:14:11 -0400
Date: Tue, 26 May 2009 15:14:10 -0700 (PDT)
Message-Id: <20090526.151410.109935435.davem@davemloft.net>
To: mb@bu3sch.de
Cc: dave@thedillows.org, michael.riepe@googlemail.com, romieu@fr.zoreil.com,
       rsantos@grupopie.com, m.bueker@berlin.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090526.145211.37114439.davem@davemloft.net>
References: <20090525.225503.173348268.davem@davemloft.net>
	<200905262022.24593.mb@bu3sch.de>
	<20090526.145211.37114439.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 26 May 2009 14:52:11 -0700 (PDT)

> From: Michael Buesch <mb@bu3sch.de>
> Date: Tue, 26 May 2009 20:22:23 +0200
> 
>> I didn't notice a CC:stable.
>> I think this should also go to stable.
>> Does somebody take care?
> 
> I'll queue it up.

Actually, this patch doesn't even remotely come close to applying
to 2.6.29.4

So if someone wants this in -stable, they need to respin this against
that tree and (if wanted) 2.6.27.x -stable as well.
