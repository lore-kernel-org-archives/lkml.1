Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZKYRyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZKYRyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbZKYRyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:54:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54957 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758099AbZKYRyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:54:44 -0500
Date: Wed, 25 Nov 2009 17:56:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 86/86] libata: add private driver field to struct
 ata_device
Message-ID: <20091125175650.64de8a10@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125171248.5446.22482.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125171248.5446.22482.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:12:48 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] libata: add private driver field to struct ata_device
> 
> This brings struct ata_device in-line with struct ata_{port,host}.

Do we need it for anything yet - whoever first needs it can add it,
otherwise its just waste.
