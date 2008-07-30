Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYG3W6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYG3W6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYG3W5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:57:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41417 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753038AbYG3W5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:57:52 -0400
Date: Wed, 30 Jul 2008 23:40:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Simen Timian Thoresen <simentt@dolphinics.no>,
       linux-kernel@vger.kernel.org
Subject: Re: Misidentification and failing revalidations of ide dvd-roms
 with libata
Message-ID: <20080730234042.22954e98@lxorguk.ukuu.org.uk>
In-Reply-To: <200807302139.40841.alistair@devzero.co.uk>
References: <48838593.8020007@dolphinics.no>
	<200807272147.42264.alistair@devzero.co.uk>
	<4890A563.70609@dolphinics.no>
	<200807302139.40841.alistair@devzero.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cmdline? This is probably a red herring though, as I'm not sure what relation 
> the sata_nv driver has to pata_amd.

None whatsoever. pata_amd drives the PATA port, sata_nv is a driver for
the older Nvidia SATA ports.
