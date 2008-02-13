Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbYBMXHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbYBMXHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYBMXG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:06:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:58064 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYBMXG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:06:57 -0500
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits
	with 64b resources"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <200802132352.46948.rjw@sisk.pl>
References: <20080204151222.GB25790@localhost.sw.ru>
	 <200802132352.46948.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 10:01:37 +1100
Message-Id: <1202943698.7296.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 23:52 +0100, Rafael J. Wysocki wrote:
> On Monday, 4 of February 2008, Alexey Dobriyan wrote:
> > Commit c40a22e0ce5eb400f27449e59e43d021bee58b8d aka
> > "PCI: Fix bus resource assignment on 32 bits with 64b resources"
> > renders one tg3-equipped box networkless here.
> 
> Has it been fixed already or is it still happening with the current mainline?

Alexey said it got fixed by some other change, could have been a BIOS
issue of some sort ?

Cheers,
Ben.


