Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZJEV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZJEV32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZJEV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:29:27 -0400
Received: from mail.perches.com ([173.55.12.10]:1887 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbZJEV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:29:27 -0400
Subject: Re: [PATCH 21/21] drivers/net/tlan.h: Convert printk(KERN_DEBUG to
 pr_dbg(
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       chessman@tux.org, netdev@vger.kernel.org
In-Reply-To: <200910052315.01357.rjw@sisk.pl>
References: <cover.1254701151.git.joe@perches.com>
	 <20091005.001240.111554671.davem@davemloft.net>
	 <1254726974.1799.315.camel@Joe-Laptop.home>
	 <200910052315.01357.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 14:28:49 -0700
Message-Id: <1254778129.1799.591.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 23:15 +0200, Rafael J. Wysocki wrote:
> Why don't you push the first patch first, then, and wait with the others until
> it gets merged?  This way individual subsystem maintainers will be able to
> merge them cleanly.

Sometimes patch series get a bit more feedback than individual patches.

Original rfc suggestion: (1 comment)
http://lkml.org/lkml/2009/10/1/399

Patch removing pr_fmt from driver (acked by Jiri):
http://lkml.org/lkml/2009/10/1/418

cheers, Joe

