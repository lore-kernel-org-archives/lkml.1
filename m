Return-Path: <linux-kernel-owner+w=401wt.eu-S966463AbXG3DR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966463AbXG3DR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 23:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965804AbXG3DRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 23:17:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52580 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbXG3DRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 23:17:17 -0400
Date: Mon, 30 Jul 2007 08:59:35 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3/5] Use mutex instead of semaphore in the SCSI Tape
 driver
In-Reply-To: <20070729213815.GF3432@traven>
Message-ID: <alpine.LFD.0.999.0707300858140.10861@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729213815.GF3432@traven>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Jul 2007, Matthias Kaehlcke wrote:

> The SCSI Tape driver uses a semaphore as mutex. Use the mutex API
> instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Reviewed-by: Satyam Sharma <satyam@infradead.org>
