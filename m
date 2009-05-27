Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbZE0Kh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbZE0Kh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 06:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbZE0Khu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 06:37:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47230 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758333AbZE0Kht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 06:37:49 -0400
Date: Wed, 27 May 2009 11:38:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Message-ID: <20090527113857.2a30e9d7@lxorguk.ukuu.org.uk>
In-Reply-To: <200905261915.47212.bzolnier@gmail.com>
References: <200905252344.11826.bzolnier@gmail.com>
	<200905261423.40117.bzolnier@gmail.com>
	<20090526135343.5bcaa92b@lxorguk.ukuu.org.uk>
	<200905261915.47212.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All information was there (kernel logs).
> 
> Moreover the default in libata is to not remove HPA settings.
> 
> I don't recommend parsing kernels logs in search of such information but
> you're are stretching the reality too far to match with your arguments.

So you disagree that sysfs is needed and propose an alternative that you
say you don't recommend (and which doesn't solve the block problem).

I used to work for a distro, and telling Bill Nottingham that the
reliable long term way for Fedora to obtain some interface data was by
grepping dmesg wouldn't have gone down well.

Alan
