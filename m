Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXB1WRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXB1WRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbXB1WRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:17:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56642
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932511AbXB1WRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:17:11 -0500
Date: Wed, 28 Feb 2007 14:17:10 -0800 (PST)
Message-Id: <20070228.141710.74748180.davem@davemloft.net>
To: clameter@engr.sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] SLUB The unqueued slab allocator V3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070228.140022.74750199.davem@davemloft.net>
References: <Pine.LNX.4.64.0702281120110.27828@schroedinger.engr.sgi.com>
	<20070228.140022.74750199.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 28 Feb 2007 14:00:22 -0800 (PST)

> V3 doesn't boot successfully on sparc64

False alarm!

This crash was actually due to an unrelated problem in the parport_pc
driver on my machine.

Slub v3 boots up and seems to work fine so far on sparc64.
