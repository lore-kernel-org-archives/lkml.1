Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYGaQgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYGaQgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYGaQfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:35:51 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:50706 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYGaQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:35:50 -0400
Date: Thu, 31 Jul 2008 18:35:46 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, mpm@selenic.com, jgarzik@pobox.com,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 3/4] Configure out ethtool support
Message-ID: <20080731183546.2b047cee@surf>
In-Reply-To: <20080731155820.GC20212@cs181140183.pp.htv.fi>
References: <1217500967.3454.140.camel@pmac.infradead.org>
	<20080731.035121.177567346.davem@davemloft.net>
	<1217503770.3454.162.camel@pmac.infradead.org>
	<20080731.043355.143045459.davem@davemloft.net>
	<1217504801.3454.170.camel@pmac.infradead.org>
	<20080731155820.GC20212@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thu, 31 Jul 2008 18:58:20 +0300,
Adrian Bunk <bunk@kernel.org> a écrit :

> It might have also made more sense to spend some of the energy used
> in this discussion instead on checking where the global 24 kB size
> increase Thomas reported for 2.6.27-rc1 compared to 2.6.26 comes from.

I agree. This is something I'm working on. I hope to have results soon.
But I *fear* that the results will be: the size growth is 10 bytes
here, 22 bytes there, 35 bytes here, spread over hundreds of patches.
Something we can do anything against.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
