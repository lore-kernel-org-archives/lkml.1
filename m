Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbZDQQhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbZDQQhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbZDQQhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:37:31 -0400
Received: from khc.piap.pl ([195.187.100.11]:47200 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbZDQQhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:37:31 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Nicholson <robert.nicholson@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Does the linux kernel contain support for ATA Security feature set?
References: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com>
	<20090417102949.6c2b663a@lxorguk.ukuu.org.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 17 Apr 2009 18:37:27 +0200
In-Reply-To: <20090417102949.6c2b663a@lxorguk.ukuu.org.uk> (Alan Cox's message of "Fri\, 17 Apr 2009 10\:29\:49 +0100")
Message-ID: <m3vdp35j94.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> it, like OSX have protective measures to stop abuse of those features.
>
> The kernel doesn't but your BIOS or in some distributions early boot
> scripts may well issue a security freeze.

A hot-plugged disk should not be affected then.
Not very safe with IDE/PATA, at least in theory.
-- 
Krzysztof Halasa
