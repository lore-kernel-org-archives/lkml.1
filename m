Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbZKYTcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbZKYTcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbZKYTcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:32:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49840 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759528AbZKYTcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:32:14 -0500
Date: Wed, 25 Nov 2009 19:34:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 82/86] pata_via: clear UDMA transfer mode bit for PIO
 and MWDMA
Message-ID: <20091125193419.2457c0ae@lxorguk.ukuu.org.uk>
In-Reply-To: <200911251910.06924.bzolnier@gmail.com>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<200911251858.38491.bzolnier@gmail.com>
	<20091125180648.6ab19725@lxorguk.ukuu.org.uk>
	<200911251910.06924.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 19:10:06 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 25 November 2009 07:06:48 pm Alan Cox wrote:
> > > Do you really find such tidy patch hard to review?
> > 
> > When doing it at speed - yes.
> 
> Do you review everybody else patches 'at speed' or only mine?

All of them when I've got a lot of stuff to do. Owing to a lack of time
machine and 500 hour days it's neccessary.

Also btw take it is a compliment - there are some people's patches I
always review in detail and it isn't the patches you expect to be *right*
that you spend the time on...

