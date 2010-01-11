Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114Ab0AKKQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0AKKQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897Ab0AKKQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:16:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48467 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440Ab0AKKQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:16:05 -0500
Date: Mon, 11 Jan 2010 10:19:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Goller <morfic@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: staging/et131x Driver Transmits but does not Receive Packets
Message-ID: <20100111101943.12611198@lxorguk.ukuu.org.uk>
In-Reply-To: <13bb8ce11001101730w640f99p72ecb1204e59f139@mail.gmail.com>
References: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
	<20100111001745.21d28340@lxorguk.ukuu.org.uk>
	<13bb8ce11001101730w640f99p72ecb1204e59f139@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> He said it has been working since 2.6.29 (for him), i could go this
> far back and see if 2.6.29 or 2.6.30 build and work for me, should i
> be able to use it with either, i could go forward until it no longer
> works and report that.

It would be interesting to know if 2.6.29 works.

> Is there anything that could be considered until then, based on the
> fact that he has a desktop PCI-e card while i have a laptop 34mm
> ExpressCard?

As I understand it they ought to behave the same - the supplied driver
has no special cases between the two.
