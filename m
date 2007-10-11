Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbXJKPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbXJKPCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbXJKPB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:01:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60222 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbXJKPB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:01:59 -0400
Date: Thu, 11 Oct 2007 17:01:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: mahamuni ashish <ash_lkp@yahoo.co.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: Getting problem while building kernel module
In-Reply-To: <546131.52217.qm@web7814.mail.in.yahoo.com>
Message-ID: <Pine.LNX.4.64.0710111701450.32234@fbirervta.pbzchgretzou.qr>
References: <546131.52217.qm@web7814.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11 2007 15:53, mahamuni ashish wrote:
>--------------------------
>[root@localhost device_driver]# make
>
>gcc -O2 -DMODULE -D__KERNEL__ -isystem 
>/usr/src/kernels/2.6.18-1.2798.fc6-i686/include   -c
>-o ins.o ins.c


Time to read Documentation/kbuild/.

