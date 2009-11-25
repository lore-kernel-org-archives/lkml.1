Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZKYR0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZKYR0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759220AbZKYR0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:26:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53903 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759240AbZKYR0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:26:40 -0500
Date: Wed, 25 Nov 2009 17:28:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/86] pata_cs5520: remove dead VDMA support
Message-ID: <20091125172846.289e739b@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170511.5446.43970.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170511.5446.43970.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:05:11 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_cs5520: remove dead VDMA support
> 
> It has been dead for the last three years (== since the initial driver
> merge) and probability that it will ever get fixed is quite low.

Agreed entirely. SIL680 VDMA might be worth doing and in turn CS5520 in
passing but CS5520 is mostly an ex-chip
