Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYGVU5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYGVU5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYGVU5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:57:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbYGVU5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:57:33 -0400
Date: Tue, 22 Jul 2008 21:39:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ondrej Zary <linux@rainbow-software.org>, Alan Cox <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080722213954.47563d6a@lxorguk.ukuu.org.uk>
In-Reply-To: <48863680.4080203@keyaccess.nl>
References: <200807042153.56644.linux@rainbow-software.org>
	<200807221959.53669.linux@rainbow-software.org>
	<20080722191022.0417f45c@lxorguk.ukuu.org.uk>
	<200807222116.19077.linux@rainbow-software.org>
	<48863680.4080203@keyaccess.nl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking at a Western Digital "FileCard 30" consisting of a Seagate 
> ST-125 and WDQC16 8-bit ISA controller. MFM I believe.
> 
> I put a sticker on it with: "io=0x320, irq=5, dma=3 615/4/26 (or 614)"

xt driver should support that including DMA 8)

