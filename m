Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbZEAQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbZEAQ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZEAQzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:55:53 -0400
Received: from parsec.stupidest.org ([71.6.196.126]:41391 "EHLO
	parsec.stupidest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZEAQzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:55:52 -0400
Date: Fri, 1 May 2009 09:55:52 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: Tree for May 1 (devtmpfs)
Message-ID: <20090501165551.GA1889@puku.stupidest.org>
References: <20090501163405.973f9088.sfr@canb.auug.org.au> <49FB1521.5050500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FB1521.5050500@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 08:28:33AM -0700, Randy Dunlap wrote:

> drivers/base/devtmpfs.c:41: error: implicit declaration of function 'vfs_mkdir'
> drivers/base/devtmpfs.c:46: error: dereferencing pointer to incomplete type

[...]

Why is devtmpfs in linux-next?  My read of the thread so far seems to
indicate there is considerable uncertainty that this is necessary or
desirable.

Without going into the meris of devtmpfs, I think if nothing else it's
still too early to make a decision on whether to merge this or not.

