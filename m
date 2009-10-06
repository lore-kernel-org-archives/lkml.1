Return-Path: <linux-kernel-owner+w=401wt.eu-S933042AbZJFSV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbZJFSV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932828AbZJFSVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:21:55 -0400
Received: from khc.piap.pl ([195.187.100.11]:48355 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641AbZJFSVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:21:54 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: sata_via: SError: { UnrecovData Proto TrStaTrns }
References: <m3my46yo5g.fsf@intrepid.localdomain>
	<19146.1202.511428.691521@pilspetsen.it.uu.se>
Date: Tue, 06 Oct 2009 20:21:15 +0200
In-Reply-To: <19146.1202.511428.691521@pilspetsen.it.uu.se> (Mikael
	Pettersson's message of "Mon, 5 Oct 2009 16:37:38 +0200")
Message-ID: <m38wfoxu1w.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> Try again with a known good SATA disk instead of the SSD.

Will do.

> What is the make and model of that mini-PCI card?

It's Commell MP-6421:
http://www.commell.com.tw/product/Peripheral/MiniPCI/MP-6421.HTM

I wonder if the BIOS (which isn't used on IXP4xx) does some fixups to
this chip?
-- 
Krzysztof Halasa
