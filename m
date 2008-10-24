Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYJXTUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYJXTUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYJXTUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:20:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57437 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025AbYJXTUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:20:01 -0400
Date: Fri, 24 Oct 2008 20:20:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       "SCSI development list" <linux-scsi@vger.kernel.org>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited
 22s
Message-ID: <20081024202002.169c8a37@lxorguk.ukuu.org.uk>
In-Reply-To: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 19:57:03 +0200
"Maciej Rutecki" <maciej.rutecki@gmail.com> wrote:

> During boot I have this message:
> 
> ata_piix 0000:00:1f.1: version 2.12
> ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ata_piix 0000:00:1f.1: setting latency timer to 64

Known bug - RC1 is broken
