Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXBZTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXBZTjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030494AbXBZTjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:39:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35160
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030491AbXBZTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:39:46 -0500
Date: Mon, 26 Feb 2007 11:39:45 -0800 (PST)
Message-Id: <20070226.113945.112853183.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] div64_64 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070226112818.1babf22a@freekitty>
References: <20070223170527.4ca695b2@freekitty>
	<20070224161916.GL3982@m.safari.iki.fi>
	<20070226112818.1babf22a@freekitty>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Mon, 26 Feb 2007 11:28:18 -0800

> asm-i386.h/div64 and div64.o needs to move in Makefile to get this to work
> on i386.

This looks great to me:

Signed-off-by: David S. Miller <davem@davemloft.net>
