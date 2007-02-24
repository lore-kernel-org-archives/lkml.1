Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbXBXA0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbXBXA0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbXBXA0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:26:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55936
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbXBXA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:26:48 -0500
Date: Fri, 23 Feb 2007 16:26:47 -0800 (PST)
Message-Id: <20070223.162647.71091566.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: msa@moth.iki.fi, linux-kernel@vger.kernel.org
Subject: Re: ipv4 and ipv6 stacks for new link layers?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070223134706.GA24864@hmsreliant.homelinux.net>
References: <200702231149.l1NBnlZD029626@moth.iki.fi>
	<20070223134706.GA24864@hmsreliant.homelinux.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 23 Feb 2007 08:47:06 -0500

> patches welcome :)

And it's a non-trivial task.  The semantics and way in which
link level encapsulation is done is not straight-forward
on some devices.

So the hooks either have to be too generic, or too specific
to be useful.
