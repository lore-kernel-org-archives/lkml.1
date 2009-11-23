Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZKWMSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZKWMSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZKWMSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:18:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbZKWMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:18:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joern Engel <joern@logfs.org>
Subject: Re: [PATCH 0/17] [LogFS] New flash filesystem
Date: Mon, 23 Nov 2009 13:18:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20091120181113.GA2159@logfs.org>
In-Reply-To: <20091120181113.GA2159@logfs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231318.39685.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/+Fcdl1gxsG7MKb+TCeQ0EvwgSKlXt1myC0bS
 roSbVdSwiitrdNCNlPKMdSRAE2SfMenbehjQcNCKZOkr0utTrC
 vZcAaOYg5/ExF5c1t1zDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 November 2009, Joern Engel wrote:
> Mails are purely for review and comments.  If this is deemed
> merge-ready, please the git tree at
> http://git.kernel.org/?p=linux/kernel/git/joern/logfs.git
> instead.

I think merging is overdue, the code looks great and if you're
happy with it to go in, it's hard for anyone to argue with
that.

It should definitely be included in linux-next, and I guess it
should have been in there for some time, to get better
compile-time coverage across architectures, and some
more testing.

I can't find it in linux-next right now, but I could be
looking at the wrong stuff again, as I have before.

	Arnd <><
