Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbYLVASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbYLVASf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 19:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYLVASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 19:18:24 -0500
Received: from khc.piap.pl ([195.187.100.11]:39236 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYLVASX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 19:18:23 -0500
To: Julia Lawall <julia@diku.dk>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/13] drivers/net/wan: Remove redundant test
References: <Pine.LNX.4.64.0812211638550.9555@pc-004.diku.dk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 22 Dec 2008 01:18:03 +0100
In-Reply-To: <Pine.LNX.4.64.0812211638550.9555@pc-004.diku.dk> (Julia Lawall's message of "Sun\, 21 Dec 2008 16\:39\:15 +0100 \(CET\)")
Message-ID: <m33aghrrk4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> writes:

> arg is checked not to be NULL a few lines before.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)

> ---
>  drivers/net/wan/pc300_drv.c         |    5 ++---

Impressive. Thanks.
-- 
Krzysztof Halasa
