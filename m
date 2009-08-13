Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZHMKVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZHMKVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZHMKVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:21:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3275 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZHMKVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:21:12 -0400
Subject: Re: [PATCH linux-next] treewide: remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.0908131155510.25797@wotan.suse.de>
References: <1248472866.3498.79.camel@Joe-Laptop.home>
	 <alpine.LNX.2.00.0908131155510.25797@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 03:21:07 -0700
Message-Id: <1250158868.28285.26.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 11:57 +0200, Jiri Kosina wrote:
> On Fri, 24 Jul 2009, Joe Perches wrote:
> 
> > Previous discussion at: http://lkml.org/lkml/2009/6/28/288
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Thanks. I have one more request if you don't mind -- please take out the 
> drivers/staging part and push that one individually to Greg. I'll then 
> merge the remaining bits through trivial tree.
> 
> The code in staging tree is supposed to be changing rapidly, so we'll be 
> getting conflicts very often.

I could do that or you could "git apply --exclude=drivers/staging/"
Which do you prefer?

