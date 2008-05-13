Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYEMECn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYEMECn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYEMECc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:02:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60007
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbYEMECb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:02:31 -0400
Date: Mon, 12 May 2008 21:02:25 -0700 (PDT)
Message-Id: <20080512.210225.167924945.davem@davemloft.net>
To: drepper@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/18] flag parameters: check magic constants
From: David Miller <davem@davemloft.net>
In-Reply-To: <482910FA.1080703@redhat.com>
References: <200805062118.m46LI74j004096@devserv.devel.redhat.com>
	<20080512201341.9ead6a9a.akpm@linux-foundation.org>
	<482910FA.1080703@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Mon, 12 May 2008 20:54:34 -0700

> This has no costs on platforms other than alpha.
> 
> Shall I sent a patch?

You'll need to handle MIPS and PARISC as well, as they have
similar conflicts.
