Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbZJNARZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbZJNARZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761722AbZJNARY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:17:24 -0400
Received: from khc.piap.pl ([195.187.100.11]:58952 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZJNARX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:17:23 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
References: <m3my46yo5g.fsf@intrepid.localdomain>
	<19147.28614.505296.752363@pilspetsen.it.uu.se>
	<m3vdii51d8.fsf@intrepid.localdomain>
Date: Wed, 14 Oct 2009 02:16:45 +0200
In-Reply-To: <m3vdii51d8.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Wed, 14 Oct 2009 01:18:43 +0200")
Message-ID: <m3r5t64yoi.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Machine A: IXP425 (ARM) CPU, 266 MHz. 64 MB RAM - this time all RAM is
> accessible to VT6421A. PCI 33 MHz (using mini-PCI adapter). Both
> little-endian and big-endian CPU modes exhibit the problems.
>
> Machine B: AMD64 X2, 64-bit kernel, 2 GB RAM. Mini-PCI 33 MHz.

Correction, the mini-PCI adapter is used to put VT6421A card into
x86-64's normal slot of course. IXP425 only has mini-PCI slot and
doesn't need the adapter.
-- 
Krzysztof Halasa
