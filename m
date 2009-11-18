Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZKRSkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZKRSkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZKRSkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:40:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1035 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZKRSkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:40:11 -0500
Subject: Re: [PATCH 1/16] drivers/net/atl1c: remove exceptional & on
 function name
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
       atl1-devel@lists.sourceforge.net, Jie Yang <jie.yang@atheros.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       arnd@arndb.de
In-Reply-To: <Pine.LNX.4.64.0911181920010.20943@ask.diku.dk>
References: <Pine.LNX.4.64.0911181920010.20943@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 10:40:15 -0800
Message-ID: <1258569615.24178.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 19:20 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In this file, function names are otherwise used as pointers without &.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)

Hi Julia, thanks for doing this.

Can you please post the complete version of the semantic patch?

