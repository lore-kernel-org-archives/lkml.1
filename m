Return-Path: <linux-kernel-owner+w=401wt.eu-S934847AbZKYRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847AbZKYRNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934827AbZKYRNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:13:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38688 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934824AbZKYRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:13:04 -0500
Date: Wed, 25 Nov 2009 17:15:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/86] pata_atiixp: add proper ->prereset method
Message-ID: <20091125171507.752343e7@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170344.5446.54715.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170344.5446.54715.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:03:44 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_atiixp: add proper ->prereset method
> 

The original seems cleaner here.
