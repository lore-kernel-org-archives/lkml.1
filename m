Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZF3KYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZF3KYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZF3KYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:24:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:57456 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZF3KYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:24:34 -0400
Subject: Re: [RFC PATCH 1/2] pci: determine CLS more intelligently
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       hancockr@shaw.ca, alan@lxorguk.ukuu.org.uk, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, daniel.ritz@gmx.ch,
       linux@dominikbrodowski.net, kaneshige.kenji@jp.fujitsu.com,
       towerlexa@gmx.de, mingo@elte.hu, tglx@linutronix.de,
       tony.luck@intel.com
In-Reply-To: <4A49815C.1080603@kernel.org>
References: <4A43234D.9050608@kernel.org>
	 <20090625.020507.203808859.davem@davemloft.net>
	 <20090625173355.GA4847@kroah.com>  <4A49815C.1080603@kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 20:22:21 +1000
Message-Id: <1246357341.31413.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 12:07 +0900, Tejun Heo wrote:
> 
> Great, I'll incorporate both comments and repost the patchset after
> Benjamin's testing or before the end of this week.

Just go ahead if you can test build powerpc. I'm on vacation on the
coast and won't be able to do much testing :-)

In any case, it shouldn't affect us (hopefully).

Cheers,
Ben.


