Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbXAVUyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbXAVUyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbXAVUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:54:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34620 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932637AbXAVUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:54:05 -0500
Date: Mon, 22 Jan 2007 21:02:32 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "John Stoffel" <john@stoffel.org>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: ATA - pata_mpiix.c support for 82371AB chipsets?
Message-ID: <20070122210232.5defa537@localhost.localdomain>
In-Reply-To: <17844.15049.520863.214543@smtp.charter.net>
References: <20070110171338.5cd555b1@localhost.localdomain>
	<17844.15049.520863.214543@smtp.charter.net>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 00:07.1 IDE interface [0101]: Intel Corporation 82371AB/EB/MB PIIX4 IDE [8086:7111] (rev 01)

This isn't an MPIIX, Use the ata_piix driver

