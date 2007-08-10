Return-Path: <linux-kernel-owner+w=401wt.eu-S1765493AbXHJWfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765493AbXHJWfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbXHJWev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:34:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbXHJWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:34:50 -0400
Date: Fri, 10 Aug 2007 15:34:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: serial patches from -mm
Message-Id: <20070810153416.d7eab8ab.akpm@linux-foundation.org>
In-Reply-To: <20070810143835.2d65be8c.akpm@linux-foundation.org>
References: <20070810143835.2d65be8c.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 14:38:35 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> I'll send these
> 
> dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
> serial-add-support-for-ite-887x-chips.patch
> serial_txx9-fix-modem-control-line-handling.patch
> serial_txx9-cleanup-includes.patch
> serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
> add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
> 
> for review, please.
> 
> I've identified these as not-for-2.6.23 which may of course have been
> incorrect.
> 

Based on an Alan ack and my own review I have queued these:

dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch

for 2.6.23 and this:

serial_txx9-cleanup-includes.patch

for 2.6.24.

