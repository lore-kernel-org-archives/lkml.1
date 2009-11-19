Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZKSSW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZKSSW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZKSSW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:22:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37703 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751893AbZKSSW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:22:57 -0500
Date: Thu, 19 Nov 2009 18:24:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pata_hpt37x: unify ->pre_reset methods
Message-ID: <20091119182457.56545e7d@lxorguk.ukuu.org.uk>
In-Reply-To: <200911191912.24663.bzolnier@gmail.com>
References: <200911191912.24663.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 19:12:24 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> We can use the same ->pre_reset method for all HPT37x chipsets now.

Nice clean up

Acked-by: Alan Cox <alan@linux.intel.com>
