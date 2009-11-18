Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZKRSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZKRSl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZKRSl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:41:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51544 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754365AbZKRSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:41:26 -0500
Date: Wed, 18 Nov 2009 18:42:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpt366: remove dead old timing tables
Message-ID: <20091118184255.40febcf0@lxorguk.ukuu.org.uk>
In-Reply-To: <200911181932.07651.bzolnier@gmail.com>
References: <200911181932.07651.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 19:32:07 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> It has been enough time since introduction of the new timing tables
> (commit 809b53c from Dec 12 2007) and the old timing tables are still
> available in pata_hpt37x.c (or git history) if somebody needs them.

(and in the HPT driver...)

Acked-by: Alan Cox <alan@linux.intel.com>
