Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYCDCgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYCDCgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYCDCf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:35:59 -0500
Received: from ozlabs.org ([203.10.76.45]:34060 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYCDCf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:35:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [BUILD_FAILURE] 2.6.24-git18 build fails section type conflict psmouse-base
Date: Tue, 4 Mar 2008 13:35:04 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <47AC2FDB.7080104@linux.vnet.ibm.com> <200803031535.17644.rusty@rustcorp.com.au> <20080303081345.GA4457@cs181133002.pp.htv.fi>
In-Reply-To: <20080303081345.GA4457@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041335.05144.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008 19:13:45 Adrian Bunk wrote:
> On Mon, Mar 03, 2008 at 03:35:16PM +1100, Rusty Russell wrote:
> > Erk... This is horrible, and arguably something gcc should try to deal
> > with. How about we just drop the const and add a comment, rather than
> > breaking one arch at a time?
>
> We should have caught all architectures having problems, and a slightly
> improved patch is now in Linus' tree.

Yes, thanks, I saw it later on in the thread.  'Tis still horrible tho :)

Rusty.
