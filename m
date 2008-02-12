Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbYBLGCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbYBLGCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYBLGBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:01:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48856
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753551AbYBLGBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:01:51 -0500
Date: Mon, 11 Feb 2008 22:02:22 -0800 (PST)
Message-Id: <20080211.220222.118805417.davem@davemloft.net>
To: tytso@mit.edu
Cc: trond.myklebust@fys.uio.no, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212051136.GA12802@mit.edu>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<1202791555.20739.6.camel@heimdal.trondhjem.org>
	<20080212051136.GA12802@mit.edu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Tso <tytso@mit.edu>
Date: Tue, 12 Feb 2008 00:11:36 -0500

> __deprecate the old one,

Deprecate is garbage, shit hangs around in the tree forever
and people just turn off the warnings.

Clean sweeps work much better, albeit with some merge pain,
we'll cope.
