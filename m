Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYBDSvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYBDSvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYBDSvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:51:07 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:47200 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbYBDSvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:51:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18343.24213.850757.370094@stoffel.org>
Date: Mon, 4 Feb 2008 13:51:01 -0500
From: "John Stoffel" <john@stoffel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: John Stoffel <john@stoffel.org>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] firewire-sbp2: misc hotplug related patches
In-Reply-To: <47A74FDC.8020201@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
	<18343.13598.546459.760900@stoffel.org>
	<47A74FDC.8020201@s5r6.in-berlin.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stefan> John Stoffel wrote:
>> I've completely given up on my Firewire/USB external enclosure with a
>> PL-3xxx chipset.

Stefan> Is it a variant whose firmware cannot be updated?

No, it can be updated, and I have done that once before.  It became a
little more stable, but not much.  I forget the details, but either
under USB or FireWire it would lockup or corrupt transfers.  

I seem to remember using the serialize_io=1 parameter too, but it
didn't help either.

>> Do you want it for further testing purposes?  I'd be
>> happy to ship it to you if you like.  

Stefan> The offer is appreciated, but as mentioned in PM, the shipping
Stefan> costs would be out of proportion.

Sure, I'd be happy to ship it to the developer you think could make
the most use of this thing.    I'll have to dig out the specs when I
get home.  Maybe look back in the archives, because I know I wrote
about this before, probably back in 2005 sometime.

John
