Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbZKYRgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbZKYRgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbZKYRgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:36:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54988 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758929AbZKYRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:36:47 -0500
Date: Wed, 25 Nov 2009 17:38:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 48/86] pata_legacy: add pointers to QDI65x0
 documentation
Message-ID: <20091125173852.71fcdf9d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170802.5446.46013.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170802.5446.46013.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + *	QDI65x0 probe code based on drivers/ide/legacy/qd65xx.c
> + *	Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
> + *	Samuel Thibault <samuel.thibault@ens-lyon.org>

It's not drivers/ide/legacy/qd65xx.c - because you moved it back in the
old IDE code.
