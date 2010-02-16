Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0BPFyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:54:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41391
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab0BPFyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:54:49 -0500
Date: Mon, 15 Feb 2010 21:55:03 -0800 (PST)
Message-Id: <20100215.215503.267631768.davem@davemloft.net>
To: andrew.hendry@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] X25: Fix x25_create errors for bad protocol and
 ENOBUFS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266148811.4731.43.camel@ibex>
References: <1266148811.4731.43.camel@ibex>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Hendry <andrew.hendry@gmail.com>
Date: Sun, 14 Feb 2010 23:00:11 +1100

> alloc_socket failures should return -ENOBUFS
> a bad protocol should return -EINVAL
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

Applied.
