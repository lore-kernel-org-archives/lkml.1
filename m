Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZLXEmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZLXEmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 23:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZLXEmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 23:42:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52550
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbZLXEmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 23:42:01 -0500
Date: Wed, 23 Dec 2009 20:42:01 -0800 (PST)
Message-Id: <20091223.204201.245388649.davem@davemloft.net>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 07/37] kgdb,sparc: Add in kgdb_arch_set_pc for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B32A1EB.2020805@windriver.com>
References: <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
	<20091223.134837.189694575.davem@davemloft.net>
	<4B32A1EB.2020805@windriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 23 Dec 2009 17:04:11 -0600

> This fix and the other fix you asked about are both in kgdb-next which
> feeds into linux-next, if you are ultimately ok with the changes, I'll
> add an ack from you as well.

Feel free to add it:

Acked-by: David S. Miller <davem@davemloft.net>
