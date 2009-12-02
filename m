Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZLBUF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZLBUF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZLBUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:05:29 -0500
Received: from mail.perches.com ([173.55.12.10]:1258 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbZLBUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:05:28 -0500
Subject: Re: [PATCH 00/13] drivers/block/floppy.c: More cleanups
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
In-Reply-To: <20091202110326.2a48e5e4@nehalam>
References: <cover.1259733456.git.joe@perches.com>
	 <20091202110326.2a48e5e4@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 12:05:34 -0800
Message-ID: <1259784334.14424.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 11:03 -0800, Stephen Hemminger wrote:
> I like seeing it as individual patches like this, but the first batch
> starts after your huge patch. Why not split that one up as well.

I've already spent too much time doing this
for something I'll never actually use.

You can do that if you choose.

The first set is a trivial combination of
printk->pr_<foo> and some emacs macro
substitution for c99 initializations.

The second set was more logical conversions
which needed to be done piecemeal.

cheers, Joe


