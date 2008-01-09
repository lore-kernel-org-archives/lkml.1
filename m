Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYAIXRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYAIXRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYAIXQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:16:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49837
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbYAIXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:16:57 -0500
Date: Wed, 09 Jan 2008 15:16:56 -0800 (PST)
Message-Id: <20080109.151656.12453500.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc64: ultra 60 fails to boot with 64kB pages
From: David Miller <davem@davemloft.net>
In-Reply-To: <200801092014.18787.m.kozlowski@tuxland.pl>
References: <200801092014.18787.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Wed, 9 Jan 2008 20:14:16 +0100

> So ... am I doing something wrong here or something is broken?

I know that non-8K page sizes are broken but haven't had time
to go fix it, sorry.
