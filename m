Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbZKYSKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbZKYSKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZKYSKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:10:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53044 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753527AbZKYSKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:10:48 -0500
Date: Wed, 25 Nov 2009 18:12:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 48/86] pata_legacy: add pointers to QDI65x0
 documentation
Message-ID: <20091125181253.14159347@lxorguk.ukuu.org.uk>
In-Reply-To: <200911251844.59772.bzolnier@gmail.com>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170802.5446.46013.sendpatchset@localhost>
	<20091125173852.71fcdf9d@lxorguk.ukuu.org.uk>
	<200911251844.59772.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:44:59 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 25 November 2009 06:38:52 pm Alan Cox wrote:
> > > + *	QDI65x0 probe code based on drivers/ide/legacy/qd65xx.c
> > > + *	Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
> > > + *	Samuel Thibault <samuel.thibault@ens-lyon.org>
> > 
> > It's not drivers/ide/legacy/qd65xx.c - because you moved it back in the
> > old IDE code.
> 
> It was the correct path/driver when the aforementioned code was added.

Sure but the path has changed so its more helpful for anyone looking back
to have the right path.
