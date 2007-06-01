Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbXFARfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbXFARfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760351AbXFARfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:35:46 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759939AbXFARfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:35:46 -0400
Date: Fri, 1 Jun 2007 10:35:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-Id: <20070601103543.5681eaa7.akpm@linux-foundation.org>
In-Reply-To: <11341.1180718845@turing-police.cc.vt.edu>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<28278.1180675923@turing-police.cc.vt.edu>
	<465FB862.207@zytor.com>
	<11341.1180718845@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007 13:27:25 -0400
Valdis.Kletnieks@vt.edu wrote:

> Do Linus/Andrew/major maintainers want Tested-By:'s for patches?

I think it's very useful information to have.  For a start, it tells
you who has the hardware and knows how to build a kernel.  So if you're
making a change to a driver and want it tested, you can troll the file's
changelog looking for people who might be able to help.

A similar argument would apply to Reported-by:, which we possibly also
need.  But it's all perhaps a bit much for poor kernel developers to
keep track of ;)
