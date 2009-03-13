Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbZCMV2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbZCMV2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbZCMV2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:28:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbZCMV2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:28:45 -0400
Date: Fri, 13 Mar 2009 14:28:31 -0700 (PDT)
Message-Id: <20090313.142831.61404425.davem@davemloft.net>
To: scott@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/31] wanrouter: Auto-load wanrouter module when
 socket opened.
From: David Miller <davem@davemloft.net>
In-Reply-To: <f00a02ec96f66d20d3206bc36c60cd6405bb7fbf.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
	<f00a02ec96f66d20d3206bc36c60cd6405bb7fbf.1236702228.git.scott@canonical.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 16:47:46 +0000

> The wanrouter module is missing the net-pf-25 alias that would cause it
> to be auto-loaded when a socket of that type is opened.  This patch adds
> the alias.
> 
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

This module has no sockets, this patch doesn't do anything.

These patches really stink, and have been prepared in a really
careless manner, sorry.
