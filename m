Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYFXBqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYFXBqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYFXBp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:45:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40225
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbYFXBp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:45:57 -0400
Date: Mon, 23 Jun 2008 18:45:57 -0700 (PDT)
Message-Id: <20080623.184557.72075822.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, johnpol@2ka.mipt.ru
Subject: Re: [PATCH] CONNECTOR: add a proc entry to list connectors
From: David Miller <davem@davemloft.net>
In-Reply-To: <48604E44.5040402@cn.fujitsu.com>
References: <48604E44.5040402@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Tue, 24 Jun 2008 09:30:44 +0800

> I got a problem when I wanted to check if the kernel supports process
> event connector, and It seems there's no way to do this check.

Try to create a connector socket.
