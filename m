Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXAYD0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXAYD0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 22:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXAYD0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 22:26:49 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:33903 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXAYD0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 22:26:49 -0500
X-Greylist: delayed 1767 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 22:26:48 EST
Date: Thu, 25 Jan 2007 04:26:47 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Intel PCI-E bridge ACPI resources and possibly related SATA
 unstability problems on ASUS A8Js
In-Reply-To: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz>
Message-ID: <Pine.LNX.4.64.0701250424480.16934@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Martin Drab wrote:

> All of this is clearly reproducible. I do not know whether this behaviour 
> is somehow related to the ACPI detection problems stated at the beginning 
> of the mail, or whether these are two different bugs. That's why I haven't 
> reported it to bugzilla yet, because I do not know which section this or 
> these (?) should belong to. But I will do so, if anyone of you shall 
> kindly give me some clue for this. Also if you need any more info or 
> testing, just ask.

OK, submitted to kernel bugzilla as bug #7883 and chosen the section 
IO/Storage Serial ATA, even though I'm not sure it's the right section 
for this.

Martin
