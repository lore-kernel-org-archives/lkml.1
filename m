Return-Path: <linux-kernel-owner+w=401wt.eu-S966440AbXG3Q3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966440AbXG3Q3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965091AbXG3Q11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:27:27 -0400
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:47351 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966724AbXG3Q1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:27:25 -0400
Date: Mon, 30 Jul 2007 19:27:20 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/5] Use mutex instead of semaphore in the SCSI Tape
 driver
In-Reply-To: <20070729213815.GF3432@traven>
Message-ID: <Pine.LNX.4.64.0707301925410.5391@kai.makisara.local>
References: <20070729212909.GC3432@traven> <20070729213815.GF3432@traven>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007, Matthias Kaehlcke wrote:

> The SCSI Tape driver uses a semaphore as mutex. Use the mutex API
> instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

Thanks.

-- 
Kai
