Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbYBMXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbYBMXI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYBMXIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:08:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbYBMXIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:08:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits with 64b resources"
Date: Thu, 14 Feb 2008 00:06:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexey Dobriyan <adobriyan@sw.ru>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
References: <20080204151222.GB25790@localhost.sw.ru> <200802132352.46948.rjw@sisk.pl> <20080213230353.GF2144@martell.zuzino.mipt.ru>
In-Reply-To: <20080213230353.GF2144@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802140006.43917.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 of February 2008, Alexey Dobriyan wrote:
> On Wed, Feb 13, 2008 at 11:52:46PM +0100, Rafael J. Wysocki wrote:
> > On Monday, 4 of February 2008, Alexey Dobriyan wrote:
> > > Commit c40a22e0ce5eb400f27449e59e43d021bee58b8d aka
> > > "PCI: Fix bus resource assignment on 32 bits with 64b resources"
> > > renders one tg3-equipped box networkless here.
> > 
> > Has it been fixed already or is it still happening with the current mainline?
> 
> It's fine now. See 20651af9ac60fd6e31360688ad44861a7d05256a aka
> "x86: fix mttr trimming".

OK, thanks.
