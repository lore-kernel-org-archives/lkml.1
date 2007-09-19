Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXISQi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXISQi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXISQit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:38:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42925
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbXISQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:38:48 -0400
Date: Wed, 19 Sep 2007 09:38:32 -0700 (PDT)
Message-Id: <20070919.093832.88002774.davem@davemloft.net>
To: max@stro.at
Cc: mchan@broadcom.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070919163318.GG6618@stro.at>
References: <20070918.112337.74737433.davem@davemloft.net>
	<1190145951.9540.230.camel@dell>
	<20070919163318.GG6618@stro.at>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: maximilian attems <max@stro.at>
Date: Wed, 19 Sep 2007 18:33:18 +0200

> we have to strip the firmware for Debian for the upcoming Lenny release.

Why do you "have to"?  The vendor has given you explicit rights
to distribute it:

 * Firmware is:
 *	Derived from proprietary unpublished source code,
 *	Copyright (C) 2000-2003 Broadcom Corporation.
 *
 *	Permission is hereby granted for the distribution of this firmware
 *	data in hexadecimal or equivalent format, provided this copyright
 *	notice is accompanying it.

This whole firmware stripping thing in debian is beyond rediculious
and only serves to hurt users.
