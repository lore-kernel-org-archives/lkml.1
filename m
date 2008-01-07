Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYAGHmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYAGHmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 02:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYAGHmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 02:42:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51824
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbYAGHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 02:42:07 -0500
Date: Sun, 06 Jan 2008 23:42:07 -0800 (PST)
Message-Id: <20080106.234207.113177790.davem@davemloft.net>
To: rol@as2917.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Module for simulating network default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080107083704.6527306e@tux.DEF.witbe.net>
References: <20080107083704.6527306e@tux.DEF.witbe.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Rolland <rol@as2917.net>
Date: Mon, 7 Jan 2008 08:37:04 +0100

> I remember reading some time ago about a network driver to "simulate"
> network default, for example packet loss...
> Unfortunately, I can't find the post, neither in my mailbox nor in
> archives...
> 
> Does anyone has an URL that you could send me ?

You want the "netem" packet scheduler, and you'll get better
answers to networking questions on the networking list
netdev@vger.kernel.org
