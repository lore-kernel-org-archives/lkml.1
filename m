Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYLOWkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYLOWkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYLOWkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:40:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34694
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbYLOWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:40:32 -0500
Date: Mon, 15 Dec 2008 14:40:34 -0800 (PST)
Message-Id: <20081215.144034.37712353.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: kkeil@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] isdn: eicon: fix sparse warning: make global
 functions static
From: David Miller <davem@davemloft.net>
In-Reply-To: <49463d0c.09c5660a.36f7.ffffc710@mx.google.com>
References: <49463d0c.09c5660a.36f7.ffffc710@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 17:59:14 +0100

> Fix this sparse warnings by making the functions static:

Can you please fix the date on your computer, it should
have been Dec 14th or 15th when you posted this :-/

This is screwing up the ordering of patches on patchwork,
since it sorts them by date, and that's how I prioritize
my work as a result.

Thanks!
