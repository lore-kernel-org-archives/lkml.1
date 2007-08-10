Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbXHJViw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbXHJViw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbXHJVio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:38:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbXHJVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:38:43 -0400
Date: Fri, 10 Aug 2007 14:38:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: serial patches from -mm
Message-Id: <20070810143835.2d65be8c.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'll send these

dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch

for review, please.

I've identified these as not-for-2.6.23 which may of course have been
incorrect.

