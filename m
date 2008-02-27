Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYB0AFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYB0AFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYB0AE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:04:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:60438 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYB0AE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:04:56 -0500
Subject: Re: [PATCH 1/3 v2] dma/doc: document
	dma_{un}map_{single|sg}_attrs() interface
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080206032128.GO9904@sgi.com>
References: <20080206032128.GO9904@sgi.com>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 11:03:10 +1100
Message-Id: <1204070590.15052.192.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

For some reason I only got some of your patches... care to resend the
whole serie with me on CC ?

We need to add similar attributes for PowerPC to support relaxed
ordering on some mappings. We started internally adding flags to the
direction, like you initially did, but it looks like that's not the
direction the wind is blowing so ..

Cheers,
Ben.


