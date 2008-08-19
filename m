Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYHSS1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYHSS1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYHSS1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:27:30 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35532 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYHSS13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:27:29 -0400
Subject: Re: [GIT]: Networking
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org>
References: <20080819.041706.261399060.davem@davemloft.net>
	 <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 20:27:31 +0200
Message-Id: <1219170451.7591.175.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> For example, those BT updates looked in no way like regression fixes.

the Bluetooth fixes do fix one regression that broke user space
assumptions.

I included additional support for one new driver since I was under the
assumption that new driver support is fine since it can't introduce a
regression. If that has changed then please spell this out and we have
to apply this rule to all subsystems.

Also I cleaned up the MAINTAINERS file entries for Bluetooth. Are these
considered harmful now and should be postponed to the next merge window?
They can obviously not introduce any regressions?

Regards

Marcel


