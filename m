Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbXEINdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbXEINdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXEINc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:32:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53835 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbXEINc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:32:58 -0400
Date: Wed, 9 May 2007 14:36:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
Message-ID: <20070509143621.282f2400@the-village.bc.nu>
In-Reply-To: <alpine.DEB.0.99.0705090308150.17598@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
	<20070508163452.8b71f682.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
	<20070508190800.1334b968.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081934390.20751@chino.kir.corp.google.com>
	<20070509102134.5d722386@the-village.bc.nu>
	<alpine.DEB.0.99.0705090308150.17598@chino.kir.corp.google.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Thus, any reliance on type-qualifying an object that represents an atomic 
> or locking primitive on the keyword 'volatile' is misplaced.

arch/foo is generally implementation specific code.
